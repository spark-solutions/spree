module Spree
  module CartPromotion
    class Fetch
    include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        promotions = Promotion.find_by_sql("#{order.promotions.active.to_sql} UNION #{Promotion.active.where(code: nil, path: nil).to_sql}")
        Right(input.merge(promotions: promotions))
      end
    end

    class Activator
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        promotions = input[:promotions]
        line_item = input[:line_item]

        promotions.each do |promotion|
          payload = {
            order: order,
            promotion: promotion,
            line_item: line_item
          }
          if (line_item && promotion.eligible?(line_item)) || promotion.eligible?(order)
            Spree::PromotionContainer['activate'].new.call(payload)
          else
            Spree::PromotionContainer['deactivate'].new.call(payload)
          end
        end
        Right(:promotion_applied)
      end
    end
  end

  module PagePromotion
    class Fetch
      include Dry::Transaction::Operation

      def call(input)
        path = input[:path].gsub(/\A\//, '')
        promotion = Promotion.active.find_by(path: path)
        if promotion.present?
          Right(input.merge(promotion: promotion))
        else
          Left(:promotion_not_found)
        end
      end
    end

    class Activator
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        promotion = input[:promotion]

        if promotion && promotion.eligible?(order)
          Spree::PromotionContainer['activate'].new.call(input)
        else
          Left(:order_not_eligible_for_promotion)
        end
      end
    end
  end

  module FreeShippingPromotion
    class Fetch
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        order_promo_ids = order.promotions.pluck(:id)
        free_shipping_promotion_ids = Spree::Promotion::Actions::FreeShipping.pluck(:promotion_id)
        promotions = Spree::Promotion.active.where(id: free_shipping_promotion_ids, path: nil)
        if promotions.any?
          Right(input.merge(promotions: promotions, order_promo_ids: order_promo_ids))
        else
          Left(:no_promotions_found)
        end
      end
    end

    class Activator
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        promotions = input[:promotions]
        order_promo_ids = input[:order_promo_ids]

        promotions.each do |promotion|
          next if promotion.code.present? && !order_promo_ids.include?(promotion.id)
          Spree::PromotionContainer['activate'].new.call(order: order, promotion: promotion) if promotion.eligible?(order)
        end
        Right(:promotion_applied)
      end
    end
  end

  module CouponCodePromotion
    class Fetch
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        order.coupon_code = input[:coupon_code]
        promotion = Promotion.active.includes(:promotion_rules, :promotion_actions).with_coupon_code(order.coupon_code)
        if promotion.present? && promotion.actions.exists?
          Right(input.merge(promotion: promotion))
        elsif Promotion.with_coupon_code(order.coupon_code).try(:expired?)
          Left(:coupon_code_expired)
        else
          Left(:coupon_code_not_found)
        end
      end
    end

    class Activator
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        promotion = input[:promotion]

        if promotion.usage_limit_exceeded?(order)
          Left(:coupon_code_max_usage)
        elsif order.promotions.include?(promotion)
          Left(:coupon_code_already_applied)
        elsif !promotion.eligible?(order)
          error = promotion.eligibility_errors.full_messages.first unless promotion.eligibility_errors.blank?
          Left(error || :coupon_code_not_eligible)
        elsif !promotion.class.order_activatable?(order)
          Left(:coupon_code_unknown_error)
        else
          result = Spree::PromotionContainer['activate'].new.call(input)

          if result.success?
            Spree::PromotionContainer['coupon_code.handle_activation_result'].new.call(input)
          else
            Left(:coupon_code_unknown_error)
          end
        end
      end
    end

    class HandleActivationResult
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        promotion = input[:promotion]

        discount = order.all_adjustments.promotion.eligible.detect do |p|
          p.source.promotion.code.try(:downcase) == order.coupon_code.downcase
        end

        # Check for applied line items.
        created_line_items = promotion.actions.detect do |a|
          Object.const_get(a.type).ancestors.include?(
            Spree::Promotion::Actions::CreateLineItems
          )
        end

        if discount || created_line_items
          order.update_totals
          order.persist_totals
          Right(:coupon_code_applied)
        elsif order.promotions.with_coupon_code(order.coupon_code)
          # if the promotion exists on an order, but wasn't found above,
          # we've already selected a better promotion
          Left(:coupon_code_better_exists)
        else
          # if the promotion was created after the order
          Left(:coupon_code_not_found)
        end
      end
    end
  end

  class ActivatePromotion
    include Dry::Transaction::Operation

    def call(input)
      promotion = input[:promotion]
      order = input[:order]

      results = promotion.actions.map do |action|
        action.perform(input)
      end
      action_taken = results.include?(true)

      if action_taken
        promotion.orders << order
        promotion.save
        Right(input)
      else
        Left(:coupon_code_unknown_error)
      end
    end
  end

  class DeactivatePromotion
    include Dry::Transaction::Operation

    def call(input)
      order = input[:order]
      promotion = input[:promotion]
      return unless promotion.class.order_activatable?(order)

      results = promotion.actions.map do |action|
        action.revert(input) if action.respond_to?(:revert)
      end

      action_taken = results.include?(true)

      if action_taken
        promotion.orders << order
        promotion.save
        action_taken
      else
        Left(:coupon_code_unknown_error)
      end
    end
  end
end
