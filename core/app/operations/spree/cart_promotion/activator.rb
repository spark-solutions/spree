module Spree
  module CartPromotion
    class Activator
      attr_accessor :activate, :deactivate
      include Dry::Transaction::Operation

      def initialize(activate: Spree::PromotionContainer['activate'].new,
                     deactivate: Spree::PromotionContainer['deactivate'].new)
        @activate = activate
        @deactivate = deactivate
      end

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
            @activate.call(payload)
          else
            @deactivate.call(payload)
          end
        end
        Right(:success)
      end
    end
  end
end
