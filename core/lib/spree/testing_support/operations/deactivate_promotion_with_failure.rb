module Test
  class DeactivatePromotionWithFailure
    include Dry::Transaction::Operation

    def call(input)
      Left(:coupon_code_unknown_error)
    end
  end
end
