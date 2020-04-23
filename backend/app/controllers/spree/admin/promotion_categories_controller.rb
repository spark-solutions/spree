module Spree
  module Admin
    class PromotionCategoriesController < ResourceController
      private

      def promotion_category_params
        return ActionController::Parameters.new.permit if params[:promotion_category].blank?
        params.require(:promotion_category).permit(
          :code, :name,
        )
      end
    end
  end
end
