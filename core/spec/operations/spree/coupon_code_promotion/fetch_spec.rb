require 'spec_helper'

describe Spree::CouponCodePromotion::Fetch do
  let(:coupon_code) { 'ASD' }
  let(:expired_coupon_code) { 'QWE' }
  let!(:order) { create(:order) }
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
  end
end
