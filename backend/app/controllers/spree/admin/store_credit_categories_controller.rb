module Spree
  module Admin
    class StoreCreditCategoriesController < ResourceController
      private

      def store_credit_category_params
        return ActionController::Parameters.new.permit if params[:store_credit_category].blank?
        params.require(:store_credit_category).permit(
          :name,
        )
      end
    end
  end
end
