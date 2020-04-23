module Spree
  module Admin
    class ReturnItemsController < ResourceController
      def location_after_save
        url_for([:edit, :admin, @return_item.customer_return.order, @return_item.customer_return])
      end

      private

      def return_item_params
        return ActionController::Parameters.new.permit if params[:return_item].blank?
        params.require(:return_item).permit(
          :acceptance_status, :acceptance_status_errors, :additional_tax_total,
          :customer_return_id, :exchange_variant_id, :included_tax_total,
          :inventory_unit_id, :override_reimbursement_type_id, :pre_tax_amount,
          :preferred_reimbursement_type_id, :reception_status, :reimbursement_id,
          :resellable, :return_authorization_id, :return_quantity, :returned,
        )
      end
    end
  end
end
