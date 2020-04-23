module Spree
  module Admin
    class PromotionsController < ResourceController
      before_action :load_data, except: :clone

      helper 'spree/admin/promotion_rules'

      def clone
        promotion = Spree::Promotion.find(params[:id])
        duplicator = Spree::PromotionHandler::PromotionDuplicator.new(promotion)

        @new_promo = duplicator.duplicate

        if @new_promo.errors.empty?
          flash[:success] = Spree.t('promotion_cloned')
          redirect_to edit_admin_promotion_url(@new_promo)
        else
          flash[:error] = Spree.t('promotion_not_cloned', error: @new_promo.errors.full_messages.to_sentence)
          redirect_to admin_promotions_url(@new_promo)
        end
      end

      protected

      def promotion_params
        return ActionController::Parameters.new.permit if params[:promotion].blank?
        params.require(:promotion).permit(Spree::Api::ApiHelpers.promotion_attributes + [
          :generate_code, :promotion_category_id,
          promotion_actions_attributes: [
            :id, :_destroy,
            :calculator_type, :position, :promotion_id, :type,
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
          ],
          promotion_rules_attributes: [
            :id, :_destroy,
            :code, :product_group_id, :promotion_id, :type, :user_id,
            :product_ids_string, :taxon_ids_string, :user_ids_string,
            :preferred_amount_min, :preferred_amount_max,
            :preferred_country_id, :preferred_match_policy,
            :preferred_operator_min, :preferred_operator_max,
            preferred_eligible_values: {},
          ],
        ])
      end

      def location_after_save
        spree.edit_admin_promotion_url(@promotion)
      end

      def load_data
        @calculators = Rails.application.config.spree.calculators.promotion_actions_create_adjustments
        @promotion_categories = Spree::PromotionCategory.order(:name)
      end

      def collection
        return @collection if defined?(@collection)

        params[:q] ||= HashWithIndifferentAccess.new
        params[:q][:s] ||= 'id desc'

        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = @search.result(distinct: true).
                      includes(promotion_includes).
                      page(params[:page]).
                      per(params[:per_page] || Spree::Config[:admin_promotions_per_page])
      end

      def promotion_includes
        [:promotion_actions]
      end
    end
  end
end
