module Spree
  class CreateUniqueAdjustment < BaseOperation

    # Creates adjustment for order
    #
    # Returns success if at least action was succesfully performed
    #
    # @param order [Order]
    # @param adjustable [Adjustable]
    # @param included [boolean]
    # @return Right with input as value when at least one action was performed
    # @return Left with :no_promotion_not_applied as value when no action was performed
    #
    def call(input)
      adjustable = input[:adjustable]
      adjustment_source = input[:adjustment_source]

      return Left(:adjustment_already_exists) if adjustment_source.adjustments.where(adjustable: adjustable).exists?
      Spree::PromotionContainer['create_adjustment'].call(input)
    end
  end
end
