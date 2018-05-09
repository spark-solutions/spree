module Spree
  class AddItemToCart < BaseService
    def call(order:, variant:, quantity: nil, options: nil)
      options ||= {}
      quantity ||= 1
      ActiveRecord::Base.transaction do
        line_item, line_item_created = add_to_line_item(order: order, variant: variant, quantity: quantity, options: options)
        ::Spree::TaxRate.adjust(order, [line_item.reload]) if line_item_created
        Spree::AfterAddOrRemove.new.call(line_item: line_item, order: order, line_item_created: line_item_created, options: options)
        success(line_item)
      end
    end

    private

    def add_to_line_item(order:, variant:, quantity:, options:)
      line_item = Spree::FindLineItemByVariant.new.execute(order: order, variant: variant, options: options)

      line_item_created = line_item.nil?
      if line_item.nil?
        opts = ::Spree::PermittedAttributes.line_item_attributes.each_with_object({}) do |attribute, result|
          result[attribute] = options[attribute]
        end.merge(currency: order.currency).delete_if { |_key, value| value.nil? }

        line_item = order.line_items.new(quantity: quantity,
                                         variant: variant,
                                         options: opts)
      else
        line_item.quantity += quantity.to_i
      end

      line_item.target_shipment = options[:shipment] if options.key? :shipment
      line_item.save!
      [line_item, line_item_created]
    end
  end
end
