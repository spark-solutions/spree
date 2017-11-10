require 'spec_helper'

describe Spree::FreeShippingPromotion::Activator do
  let(:order) { create(:order_with_line_items) }
  let(:subject) { described_class.new }
  let(:promotion) { Spree::Promotion.create(name: 'Free Shipping') }
  let(:promotion_without_action) { Spree::Promotion.create(name: 'Free Shipping') }
  let!(:action) { Spree::Promotion::Actions::FreeShipping.create(promotion: promotion) }

  describe '#call' do
    context 'with eligible promotion' do
      it 'it adds promotion to order' do
        result = subject.call(order: order, promotions: [promotion])
        expect(result.success?).to eq(true)
        expect(promotion.orders).to contain_exactly(order)
      end
    end

    context 'with promotion without actions' do
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotions: [promotion_without_action])
        expect(result.success?).to eq(true)
        expect(result.value).to eq(:promotion_applied)
        expect(promotion.orders).to eq([])
      end
    end
  end
end
