module Spree
  module PromotionActions
    class CreateItemAdjustments < BaseOperation
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
        promotion = input[:promotion]

        create_unique_adjustments.call(order: order, adjustables: order.line_items, adjustment_source: adjustment_source, label: label) do |line_item|
          promotion.line_item_actionable?(order, line_item)
        end
      end
    end
  end
end
