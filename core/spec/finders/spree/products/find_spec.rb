require 'spec_helper'

module Spree
  describe Products::Find do
    let!(:product)              { create(:product) }
    let!(:product_2)            { create(:product, discontinue_on: Time.current + 1.day) }
    let!(:deleted_product)      { create(:product, deleted_at: Time.current - 1.day) }
    let!(:discontinued_product) { create(:product, discontinue_on: Time.current - 1.day) }

    context 'discontinued' do
      it 'returns products with discontinued' do
        params = { 
          filter: {
            ids: '',
            skus: '',
            price: '',
            currency: false,
            taxons: '',
            name: false,
            options: false,
            show_deleted: false,
            show_discontinued: true
          }
        }

        products = [product, product_2, discontinued_product]

        expect(
          Spree::Products::Find.new(
            scope: Spree::Product.all,
            params: params,
            current_currency: 'USD'
          ).execute
        ).to eq products
      end
    end

    context 'deleted' do
      it 'returns products with deleted' do
        params = { filter: { show_deleted: true } }

        params = { 
          filter: {
            ids: '',
            skus: '',
            price: '',
            currency: false,
            taxons: '',
            name: false,
            options: false,
            show_deleted: true,
            show_discontinued: false
          }
        }

        products = [product, deleted_product, product_2]

        expect(
          Spree::Products::Find.new(
            scope: Spree::Product.all,
            params: params,
            current_currency: 'USD'
          ).execute
        ).to eq products
      end
    end

    context 'not discontinued and not deleted' do
      it 'returns not discontinued products' do
        params = { 
          filter: {
            ids: '',
            skus: '',
            price: '',
            currency: false,
            taxons: '',
            name: false,
            options: false,
            show_deleted: false,
            show_discontinued: false
          }
        }

        products = [product, product_2]

        expect(
          Spree::Products::Find.new(
            scope: Spree::Product.all,
            params: params,
            current_currency: 'USD'
          ).execute
        ).to eq products
      end
    end
  end
end
