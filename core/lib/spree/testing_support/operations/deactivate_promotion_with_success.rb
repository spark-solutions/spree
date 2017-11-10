module Test
  class DeactivatePromotionWithSuccess
    include Dry::Transaction::Operation

    def call(input)
      Right([true])
    end
  end
end
