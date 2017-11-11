module Spree
  class DeactivatePromotionOperation < BaseOperation

    # Tries to revert all actions existing in promotion.
    #
    # Returns success if at least action was succesfully performed
    #
    # @param order [Order]
    # @param promotion [Promotion]
    # @return Right with input as value when at least one action was performed
    # @return Left with :no_promotion_not_applied as value when no action was performed
    def call(input)
      order = input[:order]
      promotion = input[:promotion]
      return Left(:coupon_code_unknown_error) unless promotion.class.order_activatable?(order)

      results = promotion.actions.map do |action|
        action.revert(input) if action.respond_to?(:revert)
      end

      action_taken = results.include?(true)

      if action_taken
        promotion.orders << order
        promotion.save
        Right(input)
      else
        Left(:no_promotion_applied)
      end
    end
  end
end
