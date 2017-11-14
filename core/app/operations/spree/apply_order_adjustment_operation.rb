module Spree
  class ApplyOrderAdjustmentOperation < BaseOperation
    # Creates adjustment for order
    #
    # @param [Hash] input input for operation
    # @option input [Order] :order order for which it should create adjustment
    # @option input [Adjustable] :adjustable adjustable object (Order/LineItem)
    # @option input [PromotionAction] :promotion_action that creates adjustment
    #
    # @return [Right(Adjustment)] when new adjustment was created
    #
    # @return [Left(ActiveModel::Errors)] when validation of newly created adjustment failed
    #
    # @return [Left(:amount_equal_zero)] when computed amount for adjustment is equal 0
    #
    def call(input)
      order = input[:order]
      adjustable = input[:adjustable]
      promotion_action = input[:promotion_action]

      amount = promotion_action.compute_amount(adjustable)
      return Left(:amount_equal_zero) if amount == 0

      adjustment = promotion_action.adjustments.new(order: order,
                                                    adjustable: adjustable,
                                                    label: label(promotion_action),
                                                    amount: amount)
      if adjustment.save
        Right(adjustment)
      else
        Left(adjustment.errors)
      end
    end

    private

    def label(promotion_action)
      Spree.t(:promotion_label, name: promotion_action.promotion.name)
    end
  end
end
