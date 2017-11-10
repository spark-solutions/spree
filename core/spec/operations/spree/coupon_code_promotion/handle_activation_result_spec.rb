require 'spec_helper'

describe Spree::CouponCodePromotion::HandleActivationResult do
  let(:coupon_code) { 'ASD' }
  let(:order) { create(:order_with_line_items, coupon_code: coupon_code) }
  let(:promotion) { create(:promotion_with_order_adjustment, code: coupon_code) }
  let(:action) { Spree::Promotion::Actions::FreeShipping.create(promotion: promotion) }
  let(:subject) { described_class.new }

  describe '#call' do
    context 'with eligible promotion' do
      it 'it adds promotion to order' do
        Spree::PromotionContainer['activate'].new.call(order: order, promotion: promotion)
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(true)
        expect(result.value).to eq(:coupon_code_applied)
      end
    end

    context 'with wrong coupon code' do
      let(:order) { create(:order, coupon_code: 'qwe') }
      it 'fails' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_not_found)
      end
    end
  end
end
