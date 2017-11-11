module Spree
  module PagePromotion
    class HandleOperation < BaseOperation
      attr_accessor :activate

      # Initializes PagePromotion::HandleOperation with activate operation passed as param
      #
      # @param activate [BaseOperation] operation to be called to activate promotion
      def initialize(activate: Spree::PromotionContainer['activate'].new)
        @activate = activate
      end

      # Tries to activate promotion on order
      #
      # Returns success if at promotion was activated
      #
      # @param order [Order]
      # @param promotion [Promotion]
      # @return Right with :promotion_applied when promotion was activated succesfully
      # @return Left with :no_promotion_applied when promotion weren't applied
      #
      def call(input)
        if activate.call(input).success?
          Right(:promotion_applied)
        else
          Left(:no_promotion_applied)
        end
      end
    end
  end
end
