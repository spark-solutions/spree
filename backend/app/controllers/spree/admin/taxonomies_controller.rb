module Spree
  module Admin
    class TaxonomiesController < ResourceController
      private

      def taxonomy_params
        return ActionController::Parameters.new.permit if params[:taxonomy].blank?
        params.require(:taxonomy).permit(Spree::Api::ApiHelpers.stock_location_attributes + [
          :position,
        ])
      end

      def location_after_save
        if @taxonomy.created_at == @taxonomy.updated_at
          edit_admin_taxonomy_url(@taxonomy)
        else
          admin_taxonomies_url
        end
      end
    end
  end
end
