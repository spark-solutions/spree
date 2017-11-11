module Spree
  module CouponCodePromotion
    class HandleOperation < BaseOperation
      attr_accessor :activate

      # Initializes CouponCodePromotion::Activator with activate operation passed as param
      #
      # @param activate [BaseOperation] operation to be called to activate promotion
      def initialize(activate: Spree::PromotionContainer['activate'].new)
        @activate = activate
      end

      # Tries to activate promotion on order
      #
      # Returns success if at promotion was activated and applied discount/created line item
      #
      # @param order [Order] order with coupon_code attribute present
      # @param promotion [Promotion] promotion to be applied
      # @return Right with :coupon_code_applied when promotion was activated succesfully
      # @return Left with :coupon_code_better_exists when better promotion was applied to order
      # @return Left with :no_promotions_applied when no promotions were found
      #
      def call(input)
        order = input[:order]
        promotion = input[:promotion]

        if activate.call(input) && (discount_applied?(order) || created_line_item?(promotion))
          order.update_totals
          order.persist_totals
          Right(:coupon_code_applied)
        elsif order.promotions.with_coupon_code(order.coupon_code)
          # if the promotion exists on an order, but wasn't found earlier,
          # we've already selected a better promotion
          Left(:coupon_code_better_exists)
        else
          Left(:coupon_code_unknown_error)
        end
      end

      private

      def discount_applied?(order)
        order.all_adjustments.promotion.eligible.detect do |p|
          p.source.promotion.code.try(:downcase) == order.coupon_code.downcase
        end
      end

      # Check for applied line items.
      def created_line_item?(promotion)
        promotion.actions.detect do |a|
          Object.const_get(a.type).ancestors.include?(
            Spree::Promotion::Actions::CreateLineItems
          )
        end
      end
    end
  end
end
