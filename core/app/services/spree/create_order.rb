module Spree
  class CreateOrder
    def call(user:, store:, order_params: nil)
      order_params ||= {}

      default_params = {
        user: user,
        store: store,
        currency: Spree::Config[:currency],
        guest_token: GenerateToken.new.call(Spree::Order)
      }

      Spree::Order.create!(default_params.merge(order_params))
    end
  end
end
