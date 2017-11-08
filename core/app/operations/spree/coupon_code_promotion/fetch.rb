module Spree
  module CouponCodePromotion
    class Fetch
      include Dry::Transaction::Operation

      def call(input)
        order = input[:order]
        order.coupon_code = input[:coupon_code]
        promotion = Promotion.active.includes(:promotion_rules, :promotion_actions).with_coupon_code(order.coupon_code)
        if promotion.present? && promotion.actions.exists?
          Right(input.merge(promotion: promotion))
        elsif Promotion.with_coupon_code(order.coupon_code).try(:expired?)
          Left(:coupon_code_expired)
        else
          Left(:coupon_code_not_found)
        end
      end
    end
  end
end
