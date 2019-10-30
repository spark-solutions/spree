require 'spec_helper'

describe 'Product with prices in multiple currencies', type: :feature, js: true do
  context 'with USD, EUR and GBP as currencies' do
    let!(:store) { create(:store, default: true) }
    let!(:product) { create(:product) }

    before do
      create(:price, variant: product.master, currency: 'EUR', amount: 16.00)
      create(:price, variant: product.master, currency: 'GBP', amount: 23.00)
    end

    it 'can switch by currency', :js do
      visit spree.product_path(product)
      expect(page).to have_text '$19.99'
      select 'EUR', from: 'currency'
      expect(page).to have_text '€16.00'
      select 'GBP', from: 'currency'
      expect(page).to have_text '£23.00'
    end

    context 'when many supported store currencies' do
      before do
        store.update!(supported_currencies: 'EUR,GBP')
      end

      it 'will not render the currency selector' do
        visit spree.product_path(product)
        expect(page).to have_current_path(spree.product_path(product))
        expect(page).to have_css('#currency')
      end
    end

    context 'when one supported store currency' do
      before do
        store.update!(supported_currencies: 'EUR', default_currency: 'EUR')
      end

      it 'will not render the currency selector' do
        visit spree.product_path(product)
        expect(page).to have_current_path(spree.product_path(product))
        expect(page).to_not have_css('#currency')
      end
    end
  end
end
