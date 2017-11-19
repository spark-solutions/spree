module Spree
  class Promotion
    module Actions
      class CreateAdjustment < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        before_validation -> { self.calculator ||= Calculator::FlatPercentItemTotal.new }

        def perform(options = {})
          order = options[:order]
          return false if adjustments.where(adjustable: order).exists?
          apply_order_adjustment.call(order: order, adjustable: order, adjustment_source: self, label: label).success?
        end

        def compute_amount(order)
          [(order.item_total + order.ship_total - order.shipping_discount), calculator.compute(order)].min * -1
        end

        private

        def apply_order_adjustment
          Spree::PromotionActions::AdjustOrderOperation.new
        end
      end
    end
  end
end
