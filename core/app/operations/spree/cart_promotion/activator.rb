module Spree
  module CartPromotion
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
end
