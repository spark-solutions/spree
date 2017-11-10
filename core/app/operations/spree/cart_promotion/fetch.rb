module Spree
  module CartPromotion
    class Fetch < BaseOperation
    include Dry::Transaction::Operation

      # Queries database for promotions applied to order and promotions that can be applied to this order.
      #
      # Returns success if at least action was found
      #
      # @param order [Order]
      # @param line_item [LineItem]
      # @return Right with input with merged promotions as value when at least one promotion was found
      # @return Left with :no_promotions_found when no promotions were found
      #
      def call(input)
        order = input[:order]
        promotions = Promotion.find_by_sql("#{order.promotions.active.to_sql} UNION #{Promotion.active.where(code: nil, path: nil).to_sql}")

        return Left(:no_promotions_found) if promotions.empty?

        Right(input.merge(promotions: promotions))
      end
    end
  end
end
