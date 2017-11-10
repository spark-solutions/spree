require 'spec_helper'

describe Spree::CouponCodePromotion::Activator do
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

    context 'with already applied promotion' do
      let(:order) { create(:order_with_line_items, promotions: [promotion]) }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_already_applied)
      end
    end

    context 'with already expired promotion' do
      it 'doesnt add promotion to order' do
        allow(promotion).to receive(:usage_limit_exceeded?) { true }
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_max_usage)
      end
    end

    context 'with not elligible promotion' do
      let(:order) { create(:order, coupon_code: coupon_code) }
      let(:promotion) { create(:promotion_with_item_total_rule) }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq("This coupon code can't be applied to orders less than $10.00.")
      end
    end

    context 'with not activatable order' do
      let(:order) { create(:order, coupon_code: coupon_code, state: 'complete') }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_unknown_error)
      end
    end

    context 'with invalid coupon_code' do
      let(:order) { create(:order) }
      let(:promotion) { create(:promotion, code: coupon_code) }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_unknown_error)
      end
    end
  end
end
