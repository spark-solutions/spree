class Spree::HandlePromotionTransaction
  include Dry::Transaction(container: Spree::PromotionContainer)

  step :prepare, with: 'prepare'
  step :perform_actions, with: 'perform_actions'
end
