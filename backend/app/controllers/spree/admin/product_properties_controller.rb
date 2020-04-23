module Spree
  module Admin
    class ProductPropertiesController < ResourceController
      belongs_to 'spree/product', find_by: :slug
      before_action :find_properties
      before_action :setup_property, only: :index

      private

      def product_property_params
        return ActionController::Parameters.new.permit if params[:product_property].blank?
        params.require(:product_property).permit(permitted_product_property_attributes)
      end

      def find_properties
        @properties = Spree::Property.pluck(:name)
      end

      def setup_property
        @product.product_properties.build
      end
    end
  end
end
