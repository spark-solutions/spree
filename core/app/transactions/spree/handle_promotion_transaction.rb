class Spree::HandlePromotionTransaction
  include Dry::Transaction(container: Spree::PromotionContainer)

  step :fetch, with: 'fetch'
  step :activator, with: 'activator'
end
