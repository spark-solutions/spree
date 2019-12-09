require 'spec_helper'

describe 'Admin Reports - total orders spec', type: :request do
  stub_authorization!

  let!(:order1) { create(:completed_order_with_totals) }
  let!(:order2) { create(:completed_order_with_totals) }
  let!(:order3) { create(:completed_order_with_totals) }

  before do
    order1.update(completed_at: '2019-10-11')
    order2.update(completed_at: '2019-10-14')
    order3.update(completed_at: '2019-10-15')
  end

  let(:params) do
    { completed_at_min: '2019-10-11', completed_at_max: '2019-10-17' }
  end

  describe 'total_orders#show' do
    context 'with valid date range' do
      before { get '/admin/reports/total_orders.json', params: params }

      let(:json_response) { JSON.parse(response.body) }

      it 'returns 200 HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it 'return JSON data for charts' do
        expect(json_response['labels']).to eq ['2019-10-11', '2019-10-12', '2019-10-13', '2019-10-14', '2019-10-15', '2019-10-16', '2019-10-17']
        expect(json_response['data']).to   eq [1, 0, 0, 1, 1, 0, 0]
      end
    end
  end
end
