module Spree
  module Admin
    class CountriesController < ResourceController
      private

      def country_params
        return ActionController::Parameters.new.permit if params[:country].blank?
        params.require(:country).permit(Spree::Api::ApiHelpers.country_attributes)
      end

      def collection
        super.order(:name)
      end
    end
  end
end
