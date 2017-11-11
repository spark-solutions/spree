module Spree
  module PromotionActions
    class FreeShippingOperation < BaseOperation
      attr_accessor :create_unique_adjustments

      def initialize(create_unique_adjustments: Spree::PromotionContainer['create_unique_adjustments'].new)
        @create_unique_adjustments = create_unique_adjustments
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

        create_unique_adjustments.call(order: order, adjustables: order.shipments, adjustment_source: adjustment_source, label: label)
      end
    end
  end
end
