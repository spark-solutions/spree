module Spree
  class FindLineItemByVariant
    def execute(order:, variant:, options: {})
      order.line_items.detect do |line_item|
        line_item.variant_id == variant.id &&
          CompareLineItems.new.call(order: order, line_item: line_item, options: options).value
      end
    end
  end
end
