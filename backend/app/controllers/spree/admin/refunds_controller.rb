module Spree
  module Admin
    class RefundsController < ResourceController
      belongs_to 'spree/payment', find_by: :number
      before_action :load_order

      helper_method :refund_reasons

      rescue_from Spree::Core::GatewayError, with: :spree_core_gateway_error

      private

      def refund_params
        return ActionController::Parameters.new.permit if params[:refund].blank?
        params.require(:refund).permit(
          :amount, :payment_id, :refund_reason_id, :reimbursement_id, :transaction_id,
        )
      end

      def location_after_save
        admin_order_payments_path(@payment.order)
      end

      def load_order
        # the spree/admin/shared/order_tabs partial expects the @order instance variable to be set
        @order = @payment.order if @payment
      end

      def refund_reasons
        @refund_reasons ||= RefundReason.active.all
      end

      def build_resource
        super.tap do |refund|
          refund.amount = refund.payment.credit_allowed
        end
      end

      def spree_core_gateway_error(error)
        flash[:error] = error.message
        render :new
      end
    end
  end
end
