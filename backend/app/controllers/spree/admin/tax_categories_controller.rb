module Spree
  module Admin
    class TaxCategoriesController < ResourceController
      private

      def tax_category_params
        return ActionController::Parameters.new.permit if params[:tax_category].blank?
        params.require(:tax_category).permit(
          :description, :is_default, :name, :tax_code,
        )
      end
    end
  end
end
