require 'spec_helper'

describe Spree::PagePromotion::HandleOperation do
  let(:order) { create(:order_with_line_items) }
  let(:promotion) { create(:promotion_with_order_adjustment) }
  let(:subject) { described_class.new }

  describe '#call' do
    context 'with eligible promotion' do
      it 'it adds promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(true)
        expect(promotion.orders).to contain_exactly(order)
      end
    end

    context 'with promotion without actions' do
      let(:promotion) { create(:promotion) }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:no_promotion_applied)
        expect(promotion.orders).to eq([])
      end
    end

  end
end
