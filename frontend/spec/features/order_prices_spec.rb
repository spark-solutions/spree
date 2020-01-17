require 'spec_helper'

describe 'Order changing currency', type: :feature, js: true do
  let!(:product) { create(:product) }
  let(:order) { Spree::Order.incomplete.last }

  before do
    reset_spree_preferences do |config|
      config.allow_currency_change  = true
      config.show_currency_selector = true
    end

    create(:price, variant: product.master, currency: 'EUR', amount: 16.00)
    create(:price, variant: product.master, currency: 'GBP', amount: 23.00)
  end

  context 'when existing in the cart' do
    it 'changes its currency, if user switches the currency.' do
      add_to_cart(product)
      expect(page).to have_content('TOTAL $19.99')
      expect(order.currency).to eq('USD')
      select 'EUR', from: 'currency'
      expect(page).to have_content('TOTAL €16.00')
      expect(order.reload.currency).to eq('EUR')
    end
  end
end
