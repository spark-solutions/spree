module Spree
  class ActivatePromotion
    include Dry::Transaction::Operation

    def call(input)
      promotion = input[:promotion]
      order = input[:order]

      results = promotion.actions.map do |action|
        action.perform(input)
      end
      action_taken = results.include?(true)

      if action_taken
        promotion.orders << order
        promotion.save
        Right(input)
      else
        Left(:coupon_code_unknown_error)
      end
    end
  end
end
