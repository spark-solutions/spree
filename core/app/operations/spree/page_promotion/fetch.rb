module Spree
  module PagePromotion
    class Fetch
      include Dry::Transaction::Operation

      def call(input)
        path = input[:path].gsub(/\A\//, '')
        promotion = Promotion.active.find_by(path: path)
        if promotion.present?
          Right(input.merge(promotion: promotion))
        else
          Left(:promotion_not_found)
        end
      end
    end
  end
end
