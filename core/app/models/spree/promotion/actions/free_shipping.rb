module Spree
  class Promotion
    module Actions
      class FreeShipping < Spree::PromotionAction
        include Spree::AdjustmentSource

        def perform(payload = {})
          order = payload[:order]
          free_shipping_operation.call(order: order, adjustment_source: self, label: label).success?
        end

        def compute_amount(shipment)
          shipment.cost * -1
        end

        private

        def free_shipping_operation
          Spree::PromotionActions::FreeShippingOperation.new
        end
      end
    end
  end
end
