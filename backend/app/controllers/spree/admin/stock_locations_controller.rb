module Spree
  module Admin
    class StockLocationsController < ResourceController
      before_action :set_country, only: :new

      private

      def stock_location_params
        return ActionController::Parameters.new.permit if params[:stock_location].blank?
        params.require(:stock_location).permit(Spree::Api::ApiHelpers.stock_location_attributes + [
          :admin_name, :backorderable_default, :default, :propagate_all_variants,
        ])
      end

      def set_country
        @stock_location.country = Spree::Country.default
        unless @stock_location.country
          flash[:error] = Spree.t(:stock_locations_need_a_default_country)
          redirect_to admin_stock_locations_path
        end
      end
    end
  end
end
