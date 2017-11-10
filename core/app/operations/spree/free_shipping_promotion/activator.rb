module Spree
  module FreeShippingPromotion
    class Activator
      include Dry::Transaction::Operation
      attr_accessor :activate

      def initialize(activate: Spree::PromotionContainer['activate'].new)
        @activate = activate
      end

      def call(input)
        order = input[:order]
        promotions = input[:promotions]
        order_promo_ids = order.promotions.pluck(:id)

        promotions.each do |promotion|
          next if promotion.code.present? && !order_promo_ids.include?(promotion.id)
          activate.call(order: order, promotion: promotion) if promotion.eligible?(order)
        end
        Right(:promotion_applied)
      end
    end
  end
end

