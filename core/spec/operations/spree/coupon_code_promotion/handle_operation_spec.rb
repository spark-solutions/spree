require 'spec_helper'

describe Spree::CouponCodePromotion::HandleOperation do
  let(:coupon_code) { 'asd' }
  let(:order) { create(:order_with_line_items, coupon_code: coupon_code) }
  let(:promotion) { create(:promotion_with_order_adjustment, code: coupon_code) }
  let(:subject) { described_class.new }

  describe '#call' do
    context 'with eligible promotion' do
      it 'it adds promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(true)
        expect(promotion.orders).to contain_exactly(order)
      end
    end

    context 'with invalid coupon_code' do
      let(:order) { create(:order, coupon_code: 'dfgvx') }
      let(:promotion) { create(:promotion, code: coupon_code) }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_unknown_error)
      end
    end
  end
end
