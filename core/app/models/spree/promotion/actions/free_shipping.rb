module Spree
  class Promotion
    module Actions
      class FreeShipping < Spree::PromotionAction
        attr_accessor :free_shipping
        include Spree::AdjustmentSource

        def initialize(args = {}, free_shipping: Spree::PromotionContainer['promotion_actions.free_shipping'].new)
          @free_shipping = free_shipping
          super(args)
        end

        def perform(payload = {})
          order = payload[:order]
          free_shipping.call(order: order, adjustment_source: self, label: label).success?
        end

        def compute_amount(shipment)
          shipment.cost * -1
        end
      end
    end
  end
end
