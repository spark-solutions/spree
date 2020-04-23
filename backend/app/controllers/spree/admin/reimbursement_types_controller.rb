module Spree
  module Admin
    class ReimbursementTypesController < ResourceController
      def update
        invoke_callbacks(:update, :before)
        if @object.update(reimbursement_type_params)
          invoke_callbacks(:update, :after)
          respond_with(@object) do |format|
            format.html do
              flash[:success] = flash_message_for(@object, :successfully_updated)
              redirect_to location_after_save
            end
            format.js { render layout: false }
          end
        else
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { render action: :edit }
            format.js { render layout: false }
          end
        end
      end

      private

      def reimbursement_type_params
        params_hash = (@object.type || model_class.name).underscore.remove('spree/').tr('/', '_')
        params.require(params_hash.to_s).permit(
          :active, :mutable, :name, :type,
        )
      end
    end
  end
end
