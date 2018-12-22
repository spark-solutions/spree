module Spree
  class Checkout
    class SelectShippingRate
      prepend Spree::ServiceModule::Base

      def exec
        order.create_proposed_shipments
        update_shipments_rates(order, shipping_method_id) if order.shipments.any?
      end

      private

      # we don't want update totals and payments twice
      def update_shipments_rates(order, shipping_method_id)
        rates = []
        order.shipments.order(:id).each do |shipment|
          rate = shipment.shipping_rates.find_by(shipping_method_id: shipping_method_id)
          next unless rate

          rates << rate
          shipment.selected_shipping_rate_id = rate.id
          if shipment.dummy?
            shipment.cost = rate.cost
          else
            rate.update(cost: shipment.cost)
          end
          shipment.save!
        end
      end
    end
  end
end
