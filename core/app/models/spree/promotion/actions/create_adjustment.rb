module Spree
  class Promotion
    module Actions
      class CreateAdjustment < PromotionAction
        attr_accessor :create_adjustment
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        before_validation -> { self.calculator ||= Calculator::FlatPercentItemTotal.new }

        def initialize(args = {}, create_adjustment: Spree::PromotionContainer['promotion_actions.create_adjustment'].new)
          @create_adjustment = create_adjustment
          super(args)
        end

        def perform(options = {})
          order = options[:order]
          create_adjustment.call(order: order, adjustment_source: self, label: label).success?
        end

        def compute_amount(order)
          [(order.item_total + order.ship_total - order.shipping_discount), compute(order)].min * -1
        end
      end
    end
  end
end
