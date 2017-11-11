module Spree
  module PromotionActions
    class CreateAdjustmentOperation < BaseOperation
      attr_accessor :create_unique_adjustment

      def initialize(create_unique_adjustment: Spree::PromotionContainer['create_unique_adjustment'].new)
        @create_unique_adjustment = create_unique_adjustment
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

        create_unique_adjustment.call(order: order, adjustable: order, adjustment_source: adjustment_source, label: label)
      end
    end
  end
end
