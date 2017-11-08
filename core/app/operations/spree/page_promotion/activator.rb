module Spree
  module PagePromotion
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
end
