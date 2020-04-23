module Spree
  module Admin
    class ZonesController < ResourceController
      before_action :load_data, except: :index

      def new
        @zone.zone_members.build
      end

      protected

      def zone_params
        return ActionController::Parameters.new.permit if params[:zone].blank?
        params.require(:zone).permit(
          :default_tax, :description, :kind, :name, :zone_members_count,
          state_ids: [],
          country_ids: [],
          zone_members_attributes: [
            :id, :_destroy,
            :zone_id, :zoneable_id, :zoneable_type,
          ],
        )
      end

      def collection
        params[:q] ||= {}
        params[:q][:s] ||= 'name asc'
        @search = super.ransack(params[:q])
        @zones = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        @countries = Country.order(:name)
        @states = State.order(:name)
        @zones = Zone.order(:name)
      end
    end
  end
end
