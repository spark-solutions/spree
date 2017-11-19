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

          line_items = order.line_items.select { |line_item| promotion.line_item_actionable?(order, line_item) }

          create_items_adjustments.call(order: order,
                                        adjustables: line_items,
                                        adjustment_source: self,
                                        label: label,
                                        promotion: promotion).success?
        end

        def compute_amount(line_item)
          return 0 unless promotion.line_item_actionable?(line_item.order, line_item)
          [line_item.amount, calculator.compute(line_item)].min * -1
        end

        private

        def create_items_adjustments
          Spree::PromotionActions::CreateItemAdjustmentsOperation.new
        end
      end
    end
  end
end
