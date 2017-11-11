module Spree
  class Promotion
    module Actions
      class CreateItemAdjustments < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        before_validation -> { self.calculator ||= Calculator::PercentOnLineItem.new }

        def perform(options = {})
          order = options[:order]
          promotion = options[:promotion]

          create_item_adjustments_operation.call(order: order, adjustment_source: self, label: label, promotion: promotion).success?
        end

        def compute_amount(line_item)
          return 0 unless promotion.line_item_actionable?(line_item.order, line_item)
          [line_item.amount, compute(line_item)].min * -1
        end

        private

        def create_item_adjustments_operation
          Spree::PromotionContainer['promotion_actions.create_item_adjustments'].new
        end
      end
    end
  end
end
