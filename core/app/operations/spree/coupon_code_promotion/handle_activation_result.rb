module Spree
  module CouponCodePromotion
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
end
