module Spree
  module Admin
    class ReturnAuthorizationReasonsController < ResourceController
      private

      def return_authorization_reason_params
        return ActionController::Parameters.new.permit if params[:return_authorization_reason].blank?
        params.require(:return_authorization_reason).permit(
          :active, :mutable, :name,
        )
      end
    end
  end
end
