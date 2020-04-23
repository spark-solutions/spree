module Spree
  module Admin
    class ShippingCategoriesController < ResourceController
      private

      def shipping_category_params
        return ActionController::Parameters.new.permit if params[:shipping_category].blank?
        params.require(:shipping_category).permit(
          :name,
        )
      end
    end
  end
end
