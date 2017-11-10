require 'spec_helper'

describe Spree::CartPromotion::Fetch do
  let!(:order) { create(:order) }
  let!(:promotion) { create(:promotion, orders: [order]) }
  let!(:promotion2) { create(:promotion, code: nil, path: nil) }
  let!(:promotion3) { create(:promotion, code: 'asd', path: nil) }
  let(:subject) { Spree::CartPromotion::Fetch.new }

  describe '#call' do
    it 'returns promotions that should be applied' do
      result = subject.call(order: order)
      expect(result.success?).to eq(true)
      expect(result.value[:promotions]).to contain_exactly(promotion, promotion2)
      expect(result.value[:order].id).to eq(order.id)
    end
  end
end
