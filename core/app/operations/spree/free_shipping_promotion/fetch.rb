module Spree
  module FreeShippingPromotion
    class Fetch
      include Dry::Transaction::Operation

      def call(input)
        free_shipping_promotion_ids = Spree::Promotion::Actions::FreeShipping.pluck(:promotion_id)
        promotions = Spree::Promotion.active.where(id: free_shipping_promotion_ids, path: nil)
        if promotions.any?
          Right(input.merge(promotions: promotions))
        else
          Left(:no_promotions_found)
        end
      end
    end
  end
end

