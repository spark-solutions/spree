module Spree
  class ActivatePromotionOperation < BaseOperation

    # Tries to perform all actions existing in promotion.
    #
    # Returns success if at least action was succesfully performed
    #
    # @param order [Order]
    # @param promotion [Promotion]
    # @return Right with input as value when at least one action was performed
    # @return Left with :no_promotion_not_applied as value when no action was performed
    #
    def call(input)
      promotion = input[:promotion]
      order = input[:order]

      results = promotion.actions.map do |action|
        action.perform(input)
      end
      action_taken = results.include?(true)

      if action_taken
        promotion.orders << order
        promotion.save
        Right(input)
      else
        Left(:no_promotion_not_applied)
      end
    end
  end
end
