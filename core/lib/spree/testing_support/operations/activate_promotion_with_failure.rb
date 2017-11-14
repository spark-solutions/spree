module Test
  class ActivatePromotionWithFailure
    include Dry::Transaction::Operation

    def call(input)
      Left(:coupon_code_unknown_error)
    end
  end
end
