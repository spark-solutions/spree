module Spree
  module Admin
    class ReimbursementsController < ResourceController
      belongs_to 'spree/order', find_by: :number

      before_action :load_simulated_refunds, only: :edit

      rescue_from Spree::Core::GatewayError, with: :spree_core_gateway_error

      def perform
        @reimbursement.perform!
        redirect_to location_after_save
      end

      private

      def reimbursement_params
        return ActionController::Parameters.new.permit if params[:reimbursement].blank?
        params.require(:reimbursement).permit(Spree::Api::ApiHelpers.reimbursement_attributes + [
          return_items_attributes: [
            :id, :_destroy,
            :acceptance_status, :acceptance_status_errors, :additional_tax_total,
            :customer_return_id, :exchange_variant_id, :included_tax_total,
            :inventory_unit_id, :override_reimbursement_type_id, :pre_tax_amount,
            :preferred_reimbursement_type_id, :reception_status, :reimbursement_id,
            :resellable, :return_authorization_id,
          ],
        ])
      end

      def build_resource
        if params[:build_from_customer_return_id].present?
          customer_return = CustomerReturn.find(params[:build_from_customer_return_id])

          Reimbursement.build_from_customer_return(customer_return)
        else
          super
        end
      end

      def location_after_save
        if @reimbursement.reimbursed?
          admin_order_reimbursement_path(parent, @reimbursement)
        else
          edit_admin_order_reimbursement_path(parent, @reimbursement)
        end
      end

      def load_simulated_refunds
        @reimbursement_objects = @reimbursement.simulate
      end

      def spree_core_gateway_error(error)
        flash[:error] = error.message
        redirect_to edit_admin_order_reimbursement_path(parent, @reimbursement)
      end
    end
  end
end
