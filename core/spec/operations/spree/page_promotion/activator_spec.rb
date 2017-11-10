require 'spec_helper'

describe Spree::PagePromotion::Activator do
  let(:order) { create(:order_with_line_items) }
  let(:promotion) { create(:promotion) }
  let(:eligible_promotion) { create(:promotion_with_order_adjustment) }
  let(:subject) { described_class.new }

  describe '#call' do
    context 'with eligible promotion' do
      it 'it adds promotion to order' do
        result = subject.call(order: order, promotion: eligible_promotion)
        expect(result.success?).to eq(true)
        expect(eligible_promotion.orders).to contain_exactly(order)
      end
    end

    context 'with promotion without actions' do
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_unknown_error)
        expect(promotion.orders).to eq([])
      end
    end

    context 'without promotions' do
      it 'doesnt raise any exception' do
        result = subject.call(order: order, promotion: nil)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:order_not_eligible_for_promotion)
      end
    end
  end
end
