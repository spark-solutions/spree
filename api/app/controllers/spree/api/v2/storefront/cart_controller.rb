module Spree
  module Api
    module V2
      module Storefront
        class CartController < ::Spree::Api::V2::BaseController
          def add_item
            variant = Spree::Variant.find(params[:variant_id])

            spree_authorize! :update, spree_current_order, order_token
            spree_authorize! :show, variant

            dependencies[:add_item_to_cart].call(order: spree_current_order, variant: variant, quantity: params[:quantity])
            render json: serialized_current_order, status: 201
          end

          def remove_item
            variant = Spree::Variant.find(params[:variant_id])

            spree_authorize! :update, spree_current_order, order_token
            spree_authorize! :show, variant

            dependencies[:remove_item_from_cart].new.call(order: spree_current_order, variant: variant, quantity: params[:quantity])

            render json: serialized_current_order, status: 200
          end

          def set_item_quantity
            variant = Spree::Variant.find(params[:variant_id])
            line_item = spree_current_order.line_items.find_by!(variant: variant)

            spree_authorize! :update, spree_current_order, order_token

            dependencies[:set_line_item_quantity].new.call(line_item: line_item, quantity: params[:quantity].to_i)

            render json: serialized_current_order, status: 200
          end

          def apply_coupon_code
            authorize! :update, spree_current_order, order_token
            spree_current_order.coupon_code = params[:coupon_code]

            handler = PromotionHandler::Coupon.new(spree_current_order).apply

            if handler.successful?
              render json: serialized_current_order, status: 200
            else
              render json: { error: handler.error }, status: 422
            end
          end

          def empty
            spree_current_order.empty!

            render json: serialized_current_order, status: 200
          end

          private

          def dependencies
            {
              add_item_to_cart: Spree::Cart::AddItem,
              remove_item_from_cart: Spree::Cart::RemoveItem
            }
          end

          def serialized_current_order
            Spree::V2::Storefront::CartSerializer.new(spree_current_order.reload, include: [:line_items, :variants, :promotions]).serializable_hash
          end
        end
      end
    end
  end
end
