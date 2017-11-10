module Spree
  module CartPromotion
    class Fetch
    include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        promotions = Promotion.find_by_sql("#{order.promotions.active.to_sql} UNION #{Promotion.active.where(code: nil, path: nil).to_sql}")
        Right(input.merge(promotions: promotions))
      end
    end
  end
end
