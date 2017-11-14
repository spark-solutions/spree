module Test
  class ActivatePromotionWithSuccess
    include Dry::Transaction::Operation

    def call(input)
      Right([true])
    end
  end
end
