module Spree
  module PromotionActions
    class CreateAdjustment < BaseOperation
      attr_accessor :create_unique_adjustment

      def initialize(create_unique_adjustment: Spree::PromotionContainer['create_unique_adjustment'].new)
        @create_unique_adjustment = create_unique_adjustment
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

        create_unique_adjustment.call(order: order, adjustable: order, adjustment_source: adjustment_source, label: label)
      end
    end
  end
end
