module Spree
  module PromotionActions
    class CreateItemAdjustmentsOperation < BaseOperation
      attr_accessor :apply_items_adjustments

      def initialize(apply_items_adjustments: Spree::ApplyItemsAdjustmentsOperation.new)
        @apply_items_adjustments = apply_items_adjustments
      end

      # Creates additional items in order
      #
      # Returns success if at least action was succesfully performed
      #
      # @param order [Order]
      # @param adjustable [Adjustable]
      # @param included [boolean]
      # @return Right with input as value when at least one action was performed
      # @return Left with :no_promotion_not_applied as value when no action was performed
      #
      #
      def call(input)
        order = input[:order]
        adjustment_source = input[:adjustment_source]
        label = input[:label]
        promotion = input[:promotion]

        line_items = order.line_items.select { |line_item| promotion.line_item_actionable?(order, line_item) }
        apply_items_adjustments.call(order: order,
                                       adjustables: line_items,
                                       adjustment_source: adjustment_source,
                                       label: label,
                                       promotion: promotion)
      end
    end
  end
end
