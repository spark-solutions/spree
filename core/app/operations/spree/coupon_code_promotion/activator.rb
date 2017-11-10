module Spree
  module CouponCodePromotion
    class Activator
      attr_accessor :activate
      include Dry::Transaction::Operation

      def initialize(activate: Spree::PromotionContainer['activate'].new)
        @activate = activate
      end

      def call(input)
        order = input[:order]
        promotion = input[:promotion]

        if promotion.usage_limit_exceeded?(order)
          Left(:coupon_code_max_usage)
        elsif order.promotions.include?(promotion)
          Left(:coupon_code_already_applied)
        elsif !promotion.eligible?(order)
          error = promotion.eligibility_errors.full_messages.first unless promotion.eligibility_errors.blank?
          Left(error || :coupon_code_not_eligible)
        elsif !promotion.class.order_activatable?(order)
          Left(:coupon_code_unknown_error)
        else
          result = activate.call(input)

          if result.success?
            Spree::PromotionContainer['coupon_code.handle_activation_result'].new.call(input)
          else
            Left(:coupon_code_unknown_error)
          end
        end
      end
    end
  end
end
