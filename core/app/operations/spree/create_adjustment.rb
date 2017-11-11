module Spree
  class CreateAdjustment < BaseOperation

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
      order = input[:order]
      adjustable = input[:adjustable]
      adjustment_source = input[:adjustment_source]
      label = input[:label]
      included = input[:included] || false

      amount = adjustment_source.compute_amount(adjustable)
      return Left(:negative_amount) if amount == 0

      adjustment = adjustment_source.adjustments.new(order: order,
                                                     adjustable: adjustable,
                                                     label: label,
                                                     amount: amount,
                                                     included: included)
      if adjustment.save
        Right(adjustment)
      else
        Left(:adjustment_not_created)
      end
    end
  end
end
