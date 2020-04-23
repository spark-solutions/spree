module Spree
  module Admin
    class RefundReasonsController < ResourceController
      private

      def refund_reason_params
        return ActionController::Parameters.new.permit if params[:refund_reason].blank?
        params.require(:refund_reason).permit(
          :active, :mutable, :name,
        )
      end
    end
  end
end
