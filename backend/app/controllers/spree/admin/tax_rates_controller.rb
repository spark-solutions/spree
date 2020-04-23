module Spree
  module Admin
    class TaxRatesController < ResourceController
      before_action :load_data

      private

      def tax_rate_params
        return ActionController::Parameters.new.permit if params[:tax_rate].blank?
        params.require(:tax_rate).permit(
          :amount, :calculator_type, :deleted_at, :included_in_price, :name,
          :show_rate_in_label, :tax_category_id, :zone_id,
          calculator_attributes: [
            :id, :_destroy,
            :calculable_id, :calculable_type,
            :preferred_additional_item, :preferred_amount,
            :preferred_base_amount, :preferred_base_percent, :preferred_currency,
            :preferred_discount_amount, :preferred_flat_percent, :preferred_first_item, :preferred_max_items,
            :preferred_minimal_amount, :preferred_normal_amount, :preferred_percent,
            :type,
            preferred_tiers: {},
          ],
        )
      end

      def load_data
        @available_zones = Zone.order(:name)
        @available_categories = TaxCategory.order(:name)
        @calculators = TaxRate.calculators.sort_by(&:name)
      end
    end
  end
end
