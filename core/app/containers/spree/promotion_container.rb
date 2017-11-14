class Spree::PromotionContainer
  extend Dry::Container::Mixin

  register 'handle_promotion_transaction' do
    Spree::HandlePromotionTransaction
  end

  namespace 'coupon_code' do |ns|
    ns.register 'prepare' do
      Spree::CouponCodePromotion::PrepareOperation
    end

    ns.register 'handle' do
      Spree::CouponCodePromotion::HandleOperation
    end
  end

  namespace 'cart' do |ns|
    ns.register 'prepare' do
      Spree::CartPromotion::PrepareOperation
    end

    ns.register 'handle' do
      Spree::CartPromotion::HandleOperation
    end
  end

  namespace 'free_shipping' do |ns|
    ns.register 'prepare' do
      Spree::FreeShippingPromotion::PrepareOperation
    end

    ns.register 'handle' do
      Spree::FreeShippingPromotion::HandleOperation
    end
  end

  namespace 'page' do |ns|
    ns.register 'prepare' do
      Spree::PagePromotion::PrepareOperation
    end

    ns.register 'handle' do
      Spree::PagePromotion::HandleOperation
    end
  end

  register 'activate' do
    Spree::ActivatePromotionOperation
  end

  register 'deactivate' do
    Spree::DeactivatePromotionOperation
  end

  register 'adjust_order' do
    Spree::AdjustOrderOperation
  end

  register 'create_unique_adjustments' do
    Spree::ApplyItemsAdjustmentsOperation
  end


  namespace 'promotion_actions' do |ns|
    ns.register 'create_line_items' do
      Spree::PromotionActions::AddLineItemsOperation
    end

    ns.register 'revert_create_line_items' do
      Spree::PromotionActions::RevertCreateLineItemsOperation
    end

    ns.register 'create_adjustment' do
      Spree::PromotionActions::AdjustOrderOperation
    end

    ns.register 'create_item_adjustments' do
      Spree::PromotionActions::CreateItemAdjustmentsOperation
    end

    ns.register 'free_shipping' do
      Spree::PromotionActions::FreeShippingOperation
    end
  end
end
