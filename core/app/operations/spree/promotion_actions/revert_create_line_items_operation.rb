module Spree
  module PromotionActions
    class RevertCreateLineItemsOperation < BaseOperation

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
        line_items = input[:line_items]
        adjustment_source = input[:adjustment_source]

        return Left(:order_not_eligible) unless adjustment_source.eligible?(order)

        line_items.map do |item|
          line_item = order.find_line_item_by_variant(item.variant)
          next Left(:item_not_present) unless line_item.present?

          if order.contents.remove(item.variant, (item.quantity || 1))
            Right(:item_removed)
          else
            Left(:item_not_removed)
          end
        end.any?(&:success?) ? Right(:items_removed) : Left(:nothing_removed)
      end
    end
  end
end
