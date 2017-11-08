module Spree
  module FreeShippingPromotion
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
end

