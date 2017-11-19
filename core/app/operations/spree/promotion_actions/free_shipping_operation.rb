module Spree
  module PromotionActions
    class FreeShippingOperation < BaseOperation
      attr_accessor :apply_items_adjustments

      def initialize(apply_items_adjustments: Spree::ApplyItemsAdjustmentsOperation.new)
        @apply_items_adjustments = apply_items_adjustments
      end

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
        adjustment_source = input[:adjustment_source]
        label = input[:label]

        apply_items_adjustments.call(order: order,
                                     adjustables: order.shipments,
                                     adjustment_source: adjustment_source,
                                     label: label)
      end
    end
  end
end
