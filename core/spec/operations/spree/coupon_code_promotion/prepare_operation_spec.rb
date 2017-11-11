require 'spec_helper'

describe Spree::CouponCodePromotion::PrepareOperation do
  let(:coupon_code) { 'ASD' }
  let(:expired_coupon_code) { 'QWE' }
  let!(:order) { create(:order, coupon_code: coupon_code) }
  let!(:promotion) { create(:promotion, code: coupon_code) }
  let!(:action) { Spree::Promotion::Actions::FreeShipping.create(promotion: promotion) }
  let!(:expired_promotion) { create(:promotion, code: expired_coupon_code, expires_at: 1.day.ago) }
  let!(:action_in_expired) { Spree::Promotion::Actions::FreeShipping.create(promotion: expired_promotion) }
  let(:subject) { described_class.new }

  describe '#call' do
    it 'returns promotion that should be applied' do
      result = subject.call(order: order, coupon_code: coupon_code)
      expect(result.success?).to eq(true)
      expect(result.value[:promotion].id).to eq(promotion.id)
    end

    it 'fails on expired promotion' do
      result = subject.call(order: order, coupon_code: expired_coupon_code)
      expect(result.success?).to eq(false)
      expect(result.value).to eq(:coupon_code_expired)
    end

    it 'fails on non existing promotion' do
      result = subject.call(order: order, coupon_code: 'non_existing_code')
      expect(result.success?).to eq(false)
      expect(result.value).to eq(:coupon_code_not_found)
    end

    context 'with already applied promotion' do
      let(:order) { create(:order_with_line_items, promotions: [promotion]) }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, promotion: promotion, coupon_code: coupon_code)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_already_applied)
      end
    end

    context 'with already expired promotion' do
      it 'doesnt add promotion to order' do
        allow_any_instance_of(Spree::Promotion).to receive(:usage_limit_exceeded?) { true }
        result = subject.call(order: order, promotion: promotion, coupon_code: coupon_code)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_max_usage)
      end
    end

    context 'with not elligible promotion' do
      let(:order) { create(:order) }
      let(:promotion) { create(:promotion_with_item_total_rule, code: coupon_code) }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, coupon_code: coupon_code)
        expect(result.success?).to eq(false)
        expect(result.value).to eq("This coupon code can't be applied to orders less than $10.00.")
      end
    end

    context 'with not activatable order' do
      let(:order) { create(:order, state: 'complete') }
      it 'doesnt add promotion to order' do
        result = subject.call(order: order, coupon_code: coupon_code)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:coupon_code_unknown_error)
      end
    end
  end
end
