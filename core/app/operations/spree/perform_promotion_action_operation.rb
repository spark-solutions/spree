# module Spree
#   class PerformPromotionActionOperation < BaseOperation
#     attr_accessor :free_shipping, :create_adjustment, :create_item_adjustments, :create_line_items
#     def initialize(free_shipping: Spree::PromotionActions::FreeShippingOperation.new,
#                    create_adjustment: Spree::PromotionActions::CreateAdjustmentOperation.new,
#                    create_item_adjustments: Spree::PromotionActions::CreateItemAdjustmentsOperation.new,
#                    create_line_items: Spree::PromotionActions::CreateLineItemsOperation.new)
#       @free_shipping = free_shipping
#       @create_adjustment = create_adjustment
#       @create_item_adjustments = create_item_adjustments
#       @create_line_items = create_line_items
#     end

#     def call(input)
#       action = input[:action]
#       payload = input[:payload]
#       decide_operation(action.class).call(payload)
#     end

#     private

#     def decide_operation(action)
#       case action
#       when Spree::Promotion::Actions::FreeShipping then free_shipping
#       when Spree::Promotion::Actions::CreateLineItems then create_line_item
#       when Spree::Promotion::Actions::CreateRevertLineItems then create_revert_line_items
#       when Spree::Promotion::Actions::CreateAdjustment then create_adjustment
#       when Spree::Promotion::Actions::CreateItemAdjustments then create_item_adjustments
#       end
#     end
#   end
# end
