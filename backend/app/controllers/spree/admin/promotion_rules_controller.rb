class Spree::Admin::PromotionRulesController < Spree::Admin::BaseController
  helper 'spree/admin/promotion_rules'

  before_action :load_promotion, only: [:create, :destroy]
  before_action :validate_promotion_rule_type, only: :create

  def create
    @promotion_rule = @promotion_rule_type.new(promotion_rule_params)
    @promotion_rule.promotion = @promotion
    if @promotion_rule.save
      flash[:success] = Spree.t(:successfully_created, resource: Spree.t(:promotion_rule))
    end
    respond_to do |format|
      format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
      format.js   { render layout: false }
    end
  end

  def destroy
    @promotion_rule = @promotion.promotion_rules.find(params[:id])
    if @promotion_rule.destroy
      flash[:success] = Spree.t(:successfully_removed, resource: Spree.t(:promotion_rule))
    end
    respond_to do |format|
      format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
      format.js   { render layout: false }
    end
  end

  private

  def load_promotion
    @promotion = Spree::Promotion.find(params[:promotion_id])
  end

  def validate_promotion_rule_type
    requested_type = params[:promotion_rule].delete(:type)
    promotion_rule_types = Rails.application.config.spree.promotions.rules
    @promotion_rule_type = promotion_rule_types.detect do |klass|
      klass.name == requested_type
    end
    unless @promotion_rule_type
      flash[:error] = Spree.t(:invalid_promotion_rule)
      respond_to do |format|
        format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
        format.js   { render layout: false }
      end
    end
  end

  def promotion_rule_params
    return ActionController::Parameters.new.permit if params[:promotion_rule].blank?
    params.require(:promotion_rule).permit(
      :code, :product_group_id, :promotion_id, :type, :user_id,
      :product_ids_string, :taxon_ids_string, :user_ids_string,
      :preferred_amount_min, :preferred_amount_max,
      :preferred_country_id, :preferred_match_policy,
      :preferred_operator_min, :preferred_operator_max,
      preferred_eligible_values: {},
    )
  end
end
