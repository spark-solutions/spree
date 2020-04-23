module Spree
  module Admin
    class RolesController < ResourceController
      private

      def role_params
        return ActionController::Parameters.new.permit if params[:role].blank?
        params.require(:role).permit(
          :name,
        )
      end
    end
  end
end
