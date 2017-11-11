module Spree
  class Promotion
    module Actions
      class CreateAdjustment < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        before_validation -> { self.calculator ||= Calculator::FlatPercentItemTotal.new }

        def perform(options = {})
          order = options[:order]
          create_adjustment_operation.call(order: order, adjustment_source: self, label: label).success?
        end

        def compute_amount(order)
          [(order.item_total + order.ship_total - order.shipping_discount), compute(order)].min * -1
        end

        private

        def create_adjustment_operation
          Spree::PromotionContainer['promotion_actions.create_adjustment'].new
        end
      end
    end
  end
end
