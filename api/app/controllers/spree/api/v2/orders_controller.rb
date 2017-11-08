module Spree
  module Api
    module V2
      class OrdersController < Spree::Api::V2::BaseController
        skip_before_action :authenticate_user, only: :apply_coupon_code

        def apply_coupon_code
          order = Spree::Order.lock(false).find_by!(number: params[:id])
          authorize! :update, order, order_token

          @result = transaction.call(order: order, coupon_code: params[:coupon_code])
          status = @result.success? ? 200 : 422
          render 'spree/api/v2/promotions/result', status: status
        end

        private

        def transaction
          @transaction ||= Spree::PromotionContainer['handle_promotion_transaction'].new
        end

        def order_id
          super || params[:id]
        end
      end
    end
  end
end
