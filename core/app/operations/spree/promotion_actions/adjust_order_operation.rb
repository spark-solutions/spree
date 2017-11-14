module Spree
  module PromotionActions
    #possible rename
    class AdjustOrderOperation < BaseOperation
      attr_accessor :apply_order_adjustment

      def initialize(apply_order_adjustment: Spree::PromotionContainer['apply_order_adjustment'].new)
        @apply_order_adjustment = apply_order_adjustment
      end

      # Creates adjustment for order
      #
      # Returns success if at least action was succesfully performed
      #
      # @param order [Order] order to perform promotion actions
      # @param adjustment_source [AdjustmentSource] promotion action
      # @param included [Boolean] ???
      # @param label [String] label for adjustment
      # @return Right with input as value when at least one action was performed
      # @return Left with :adjustment_already_exists as value when action was already added to this order
      # @return Left with :amount_equal_zero as value when adjustment amount is equal 0
      # @return Left with :adjustment_not_created when some filed was missed
      #
      def call(input)
        order = input[:order]
        adjustment_source = input[:adjustment_source]
        label = input[:label]

        if adjustment_source.adjustments.where(adjustable: order).exists?
          Left(:adjustment_already_exists)
        else
          apply_order_adjustment.call(order: order, adjustable: order, adjustment_source: adjustment_source, label: label)
        end
      end
    end
  end
end
