module Spree
  module CouponCodePromotion
    class PrepareOperation < BaseOperation

      # Queries database for active promotion with coupon code passed as param
      #
      # Returns success if promotion that didn't expired was found
      #
      # @param order [Order]
      # @param coupon_code [String]
      # @return Right with input with merged promotion as value when at promotion was found
      # @return Left with :coupon_code_not_found when promotion weren't found
      # @return Left with :coupon_code_expired when found promotion is already expired
      # @return Left with :coupon_code_max_usage when found promotion is out of uses
      # @return Left with :coupon_code_already_applied when found promotion is already applied to order
      # @return Left with :coupon_code_unknown_error when order cannot have activated promotion
      #
      def call(input)
        order = input[:order]
        coupon_code = input[:coupon_code]
        order.coupon_code = coupon_code
        promotion = Promotion.active.includes(:promotion_rules, :promotion_actions).with_coupon_code(coupon_code)

        return Left(:coupon_code_expired) if Promotion.with_coupon_code(order.coupon_code).try(:expired?)
        return Left(:coupon_code_not_found) unless promotion.present? && promotion.actions.exists?
        return Left(:coupon_code_max_usage) if promotion.usage_limit_exceeded?(order)
        return Left(:coupon_code_already_applied) if order.promotions.include?(promotion)
        return Left(:coupon_code_unknown_error) if !promotion.class.order_activatable?(order)

        if promotion.eligible?(order)
          Right(input.merge(promotion: promotion))
        else
          error = promotion.eligibility_errors.full_messages.first unless promotion.eligibility_errors.blank?
          Left(error || :coupon_code_not_eligible)
        end
      end
    end
  end
end
