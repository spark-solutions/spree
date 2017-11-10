class Spree::PromotionContainer
  extend Dry::Container::Mixin

  register 'handle_promotion_transaction' do
    Spree::HandlePromotionTransaction
  end

  register 'fetch' do
    Spree::CouponCodePromotion::Fetch.new
  end

  register 'activator' do
    Spree::CouponCodePromotion::Activator.new
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
end
