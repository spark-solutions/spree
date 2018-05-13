module Spree
  module Api
    module V2
      module Storefront
        class CartController < ::Spree::Api::V2::BaseController
          def add_item
            variant = Spree::Variant.find(params[:variant_id])

            spree_authorize! :update, current_order, order_token
            spree_authorize! :show, variant

            dependencies[:add_item_to_cart].call(order: current_order, variant: variant, quantity: params[:quantity])
            render json: Spree::V2::CartSerializer.new(current_order.reload, include: [:line_items, :variants, :promotions]).serializable_hash, status: 201
          end

          def remove_item
            variant = Spree::Variant.find(params[:variant_id])

            spree_authorize! :update, current_order, order_token
            spree_authorize! :show, variant

            dependencies[:remove_item_from_cart].new.call(order: current_order, variant: variant, quantity: params[:quantity])

            render json: Spree::V2::CartSerializer.new(current_order.reload, include: [:line_items, :variants, :promotions]).serializable_hash, status: 201
          end

          def set_item_quantity
            variant = Spree::Variant.find(params[:variant_id])
            line_item = Spree::LineItem.find_by(order: current_order, variant: variant)

            spree_authorize! :update, current_order, order_token

            dependencies[:set_line_item_quantity].new.call(line_item: line_item, quantity: params[:quantity].to_i)

            render json: Spree::V2::CartSerializer.new(current_order.reload, include: [:line_items, :variants, :promotions]).serializable_hash, status: 201
          end

          def apply_coupon_code
            authorize! :update, current_order, order_token
            current_order.coupon_code = params[:coupon_code]

            handler = PromotionHandler::Coupon.new(current_order).apply

            if handler.successful?
              render json: Spree::V2::CartSerializer.new(current_order.reload, include: [:line_items, :variants, :promotions]).serializable_hash, status: 201
            else
              render json: { error: handler.error }, status: 422
            end
          end

          def empty
            current_order.empty!

            render json: Spree::V2::CartSerializer.new(current_order.reload, include: [:line_items, :variants, :promotions]).serializable_hash, status: 201
          end

          private

          def dependencies
            {
              add_item_to_cart: Spree::AddItemToCart.new,
              remove_item_from_cart: Spree::RemoveItemFromCart.new
            }
          end
        end
      end
    end
  end
end
