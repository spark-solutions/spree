require 'spec_helper'

describe Spree::FreeShippingPromotion::PrepareOperation do
  let!(:order) { create(:order) }
  let(:subject) { described_class.new }

  describe '#call' do
    context 'promotion exists' do
      let(:promotion) { Spree::Promotion.create(name: 'Free Shipping') }
      let!(:action) { Spree::Promotion::Actions::FreeShipping.create(promotion: promotion) }

      it 'returns promotion that should be applied' do
        result = subject.call(order: order)
        expect(result.success?).to eq(true)
        expect(result.value[:promotions]).to contain_exactly(promotion)
      end
    end
    it 'fails on non existing promotion' do
      result = subject.call(order: order)
      expect(result.success?).to eq(false)
      expect(result.value).to eq(:no_promotions_found)
    end
  end
end
