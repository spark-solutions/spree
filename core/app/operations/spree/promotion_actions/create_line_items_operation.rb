module Spree
  module PromotionActions
    class CreateLineItemsOperation < BaseOperation

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
          current_quantity = order.quantity_of(item.variant)

          next Left(:already_present) unless current_quantity < item.quantity
          next Left(:item_unavailable) unless item_available?(item)

          if order.contents.add(item.variant, item.quantity - current_quantity).try(:valid?)
            Right(:item_added)
          else
            Left(:item_not_added)
          end
        end.any?(&:success?) ? Right(:items_added) : Left(:nothing_added)
      end

      private

      def item_available?(item)
        quantifier = Spree::Stock::Quantifier.new(item.variant)
        quantifier.can_supply? item.quantity
      end
    end
  end
end
