module Spree
  class CreateUniqueAdjustmentsOperation < BaseOperation

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
      adjustables = input[:adjustables]
      adjustment_source = input[:adjustment_source]
      label = input[:label]
      promotion = input[:promotion]

      already_adjusted_ids = adjustment_source.adjustments.where(order: order).pluck(:adjustable_id)

      result = adjustables.where.not(id: already_adjusted_ids).map do |adjustable|
        next Left(:not_performed) unless !block_given? || yield(adjustable)
        Spree::PromotionContainer['create_adjustment'].call(order: order, adjustable: adjustable, adjustment_source: adjustment_source, label: label)
      end

      result.any?(&:success?) ? Right(:adjustable_created) : Left(:no_adjustable_created)
    end
  end
end
