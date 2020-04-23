module Spree
  module Admin
    class StatesController < ResourceController
      belongs_to 'spree/country'
      before_action :load_data

      def index
        respond_with(@collection) do |format|
          format.html
          format.js { render partial: 'state_list' }
        end
      end

      protected

      def state_params
        return ActionController::Parameters.new.permit if params[:state].blank?
        params.require(:state).permit(Spree::Api::ApiHelpers.state_attributes)
      end

      def location_after_save
        admin_country_states_url(@country)
      end

      def collection
        super.order(:name)
      end

      def load_data
        @countries = Country.order(:name)
      end
    end
  end
end
