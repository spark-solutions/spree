class Spree::Shipment::RemoveLineItemTransaction
  include Dry::Transaction

  map :remove_order_contents
  map :eventually_destroy_shipment

  private

  def remove_order_contents(input)
    variant = input[:variant]
    shipment = input[:shipment]
    quantity = shipment.inventory_units.sum(&:quantity)
    shipment.order.contents.remove(variant, quantity, shipment: shipment)

    input.merge(quantity: quantity)
  end

  def eventually_destroy_shipment(input)
    shipment = input[:shipment]

    if shipment.inventory_units.any?
      shipment.reload
    else
      shipment.destroy!
    end

    shipment
  end
end
