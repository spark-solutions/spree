require 'spec_helper'

describe 'Admin Reports - top products by line item totals spec', type: :request do
  stub_authorization!

  let!(:order1) { create(:completed_order_with_totals) }
  let!(:order2) { create(:completed_order_with_totals) }
  let!(:order3) { create(:completed_order_with_totals) }

  let(:product1) { create(:product, price: 10) }
  let(:product2) { create(:product, price: 20) }

  let(:variant1) { create(:variant, product: product1, price: 90)}

  before do
    order1.update(completed_at: '2019-10-11')
    order2.update(completed_at: '2019-10-14')
    order3.update(completed_at: '2019-10-15')

    order1.line_items.first.update(quantity: 3, variant: product1.master)
    order2.line_items.first.update(quantity: 2, variant: variant1)
    order3.line_items.first.update(quantity: 1, variant: product2.master)

    order1.line_items.each { |li| li.update_price; li.save! }
    order2.line_items.each { |li| li.update_price; li.save! }
    order3.line_items.each { |li| li.update_price; li.save! }
  end

  let(:params) do
    { date_from: '2019-10-11', date_to: '2019-10-17' }
  end

  describe 'top_products_by_line_item_totals#show' do
    context 'with valid date range' do
      before { get '/admin/reports/top_products_by_line_item_totals.json', params: params }

      let(:json_response) { JSON.parse(response.body) }

      it 'returns 200 HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it 'return JSON data for charts' do
        pp json_response['data']
        expect(json_response['labels']).to eq [
          variant1.descriptive_name,
          product1.master.descriptive_name,
          product2.master.descriptive_name
        ]
        expect(json_response['data'].map(&:to_f)).to eq [180, 30, 20]
      end
    end

    context 'generate csv report' do
      context 'without date range' do
        let(:csv_response) { "sku,line_item_totals\n" }

        before { get '/admin/reports/top_products_by_line_item_totals.csv' }

        it 'returns 200 HTTP status' do
          expect(response).to have_http_status(:ok)
        end

        it 'return CSV data' do
          expect(response.body).to eq csv_response
          expect(response.headers['Content-Disposition']).to eq "attachment; filename=\"top_products_by_line_item_totals.csv\"; filename*=UTF-8''top_products_by_line_item_totals.csv"
          expect(response.headers['Content-Type']).to eq 'text/csv'
        end
      end
    end
  end
end
