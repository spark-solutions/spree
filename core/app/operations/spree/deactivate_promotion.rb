module Spree
  class DeactivatePromotion
    include Dry::Transaction::Operation

    def call(input)
      order = input[:order]
      promotion = input[:promotion]
      return Left(:coupon_code_unknown_error) unless promotion.class.order_activatable?(order)

      results = promotion.actions.map do |action|
        action.revert(input) if action.respond_to?(:revert)
      end

      action_taken = results.include?(true)

      if action_taken
        promotion.orders << order
        promotion.save
        action_taken
      else
        Left(:coupon_code_unknown_error)
      end
    end
  end
end
