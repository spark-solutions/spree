module Spree
  class ApplyItemsAdjustmentsOperation < BaseOperation
    # Creates unique adjustments for passed collection
    #
    # @param [Hash] input input for operation
    # @option input [Order] :order order for which it should create adjustment
    # @option input [Adjustable] :adjustable adjustable object (Order/LineItem)
    # @option input [AdjustmentSource] :adjustment_source source object of adjustment(Promotion/Tax)
    #
    # @return [Right(Adjustment)] when new adjustment was created
    #
    # @return [Left(ActiveModel::Errors)] when validation of newly created adjustment failed
    #
    # @return [Left(:adjustment_already_exists)] when same adjustment already exists
    #
    def call(input)
      order = input[:order]
      adjustables = input[:adjustables]
      adjustment_source = input[:adjustment_source]
      label = input[:label]

      existing_adjustments_id = adjustment_source.adjustments.where(order: order).pluck(:adjustable_id)

      result = adjustables.where.not(id: existing_adjustments_id).map do |adjustable|
        Spree::AdjustOrderOperation.new.call(order: order,
                                             adjustable: adjustable,
                                             adjustment_source: adjustment_source,
                                             label: label)
      end

      result.any?(&:success?) ? Right(result.reject(&:failure?)) : Left(result.reject(&:success?))
    end
  end
end
