module Spree
  module FreeShippingPromotion
    class HandleOperation < BaseOperation
      attr_accessor :activate

      # Initializes FreeShippingPromotion::Activator with activate operation passed as param
      #
      # @param activate [BaseOperation] operation to be called to activate promotion
      def initialize(activate: Spree::PromotionContainer['activate'].new)
        @activate = activate
      end

      # Tries to activate promotion on order
      #
      # Returns success if at least one promotion was activated
      #
      # @param order [Order] order with coupon_code attribute present
      # @return Right with :promotions_applied when promotion was activated succesfully
      # @return Left with :no_promotions_applied when no promotions were applied
      #
      def call(input)
        order = input[:order]
        promotions = input[:promotions]
        order_promo_ids = order.promotions.pluck(:id)

        result = promotions.each do |promotion|
          next if promotion.code.present? && !order_promo_ids.include?(promotion.id)
          activate.call(order: order, promotion: promotion) if promotion.eligible?(order)
        end

        if result.any?
          Right(:promotion_applied)
        else
          Right(:promotion_not_applied)
        end
      end
    end
  end
end

