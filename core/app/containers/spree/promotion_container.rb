class Spree::PromotionContainer
  extend Dry::Container::Mixin

  register 'handle_promotion_transaction' do
    Spree::HandlePromotionTransaction
  end

  namespace 'coupon_code' do |ns|
    ns.register 'fetch' do
      Spree::CouponCodePromotion::Fetch
    end

    ns.register 'activator' do
      Spree::CouponCodePromotion::Activator
    end

    ns.register 'handle_activation_result' do
      Spree::CouponCodePromotion::HandleActivationResult
    end
  end

  namespace 'cart' do |ns|
    ns.register 'fetch' do
      Spree::CartPromotion::Fetch
    end

    ns.register 'activator' do
      Spree::CartPromotion::Activator
    end
  end

  namespace 'free_shipping' do |ns|
    ns.register 'fetch' do
      Spree::FreeShippingPromotion::Fetch
    end

    ns.register 'activator' do
      Spree::FreeShippingPromotion::Activator
    end
  end

  namespace 'page' do |ns|
    ns.register 'fetch' do
      Spree::PagePromotion::Fetch
    end

    ns.register 'activator' do
      Spree::PagePromotion::Activator
    end
  end

  register 'activate' do
    Spree::ActivatePromotion
  end

  register 'deactivate' do
    Spree::DeactivatePromotion
  end

  register 'create_adjustment' do
    Spree::CreateAdjustment
  end

  register 'create_unique_adjustment' do
    Spree::CreateUniqueAdjustment
  end

  register 'create_unique_adjustments' do
    Spree::CreateUniqueAdjustments
  end


  namespace 'promotion_actions' do |ns|
    ns.register 'create_line_items' do
      Spree::PromotionActions::CreateLineItems
    end

    ns.register 'revert_create_line_items' do
      Spree::PromotionActions::RevertCreateLineItems
    end

    ns.register 'create_adjustment' do
      Spree::PromotionActions::CreateAdjustment
    end

    ns.register 'create_item_adjustments' do
      Spree::PromotionActions::CreateItemAdjustments
    end

    ns.register 'free_shipping' do
      Spree::PromotionActions::FreeShipping
    end
  end
end
