module Spree
  module PagePromotion
    class Activator
      attr_accessor :activate
      include Dry::Transaction::Operation

      def initialize(activate: Spree::PromotionContainer['activate'].new)
        @activate = activate
      end

      def call(input)
        order = input[:order]
        promotion = input[:promotion]

        if promotion && promotion.eligible?(order)
          activate.call(input)
        else
          Left(:order_not_eligible_for_promotion)
        end
      end
    end
  end
end
