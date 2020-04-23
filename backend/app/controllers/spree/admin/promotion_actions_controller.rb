class Spree::Admin::PromotionActionsController < Spree::Admin::BaseController
  before_action :load_promotion, only: [:create, :destroy]
  before_action :validate_promotion_action_type, only: :create

  def create
    @calculators = Spree::Promotion::Actions::CreateAdjustment.calculators
    promotion_action_class = Spree::PromotionAction.descendants.detect{|klass| klass.name == params[:action_type]}
    @promotion_action = promotion_action_class.new(promotion_action_params)
    @promotion_action.promotion = @promotion
    if @promotion_action.save
      flash[:success] = Spree.t(:successfully_created, resource: Spree.t(:promotion_action))
    end
    respond_to do |format|
      format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
      format.js   { render layout: false }
    end
  end

  def destroy
    @promotion_action = @promotion.promotion_actions.find(params[:id])
    if @promotion_action.destroy
      flash[:success] = Spree.t(:successfully_removed, resource: Spree.t(:promotion_action))
    end
    respond_to do |format|
      format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
      format.js   { render layout: false }
    end
  end

  private

  def promotion_action_params
    return ActionController::Parameters.new.permit if params[:promotion_action].blank?
    params.require(:promotion_action).permit(
      :position, :calculator_type, :promotion_id, :type,
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
      promotion_action_line_items_attributes: [
        :id, :_destroy,
        :promotion_action_id, :quantity, :variant_id,
      ],
    )
  end

  def load_promotion
    @promotion = Spree::Promotion.find(params[:promotion_id])
  end

  def validate_promotion_action_type
    valid_promotion_action_types = Rails.application.config.spree.promotions.actions.map(&:to_s)
    unless valid_promotion_action_types.include?(params[:action_type])
      flash[:error] = Spree.t(:invalid_promotion_action)
      respond_to do |format|
        format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
        format.js   { render layout: false }
      end
    end
  end
end
