module Spree
  module PagePromotion
    class PrepareOperation < BaseOperation
      # Queries database for promotion with path passed as param
      #
      # Returns success if at promotion was found
      #
      # @param order [Order]
      # @param path [String]
      # @return Right with input with merged promotion when promotion was found
      # @return Left with :promotion_not_found when no promotions were found
      #
      def call(input)
        path = input[:path].gsub(/\A\//, '')
        promotion = Promotion.active.find_by(path: path)

        return Left(:promotion_not_found) if promotion.nil?
        return Left(:order_not_elligible_for_promotion) unless promotion.eligible?(order)

        Right(input.merge(promotion: promotion))
      end
    end
  end
end
