class Spree::HandlePromotionTransaction
  include Dry::Transaction(container: Spree::PromotionContainer)

  step :prepare, with: 'coupon_code.prepare'
  step :handle, with: 'coupon_code.handle'
end
