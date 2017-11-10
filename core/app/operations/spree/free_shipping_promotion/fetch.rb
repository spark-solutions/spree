module Spree
  module FreeShippingPromotion
    class Fetch < BaseOperation

      # Queries database for promotions with free shipping action that can be applied
      #
      # Returns success if at least one promotion was found
      #
      # @param order [Order]
      # @return Right with input with merged promotions as value when at least one promotion was found
      # @return Left with :no_promotions_found when no promotions were found
      #
      def call(input)
        free_shipping_promotion_ids = Spree::Promotion::Actions::FreeShipping.pluck(:promotion_id)
        promotions = Spree::Promotion.active.where(id: free_shipping_promotion_ids, path: nil)

        return Left(:no_promotions_found) unless promotions.any?

        Right(input.merge(promotions: promotions))
      end
    end
  end
end

