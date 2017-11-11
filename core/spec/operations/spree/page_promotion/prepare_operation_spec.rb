require 'spec_helper'

describe Spree::PagePromotion::PrepareOperation do
  let(:path) { 'some_path' }
  let!(:order) { create(:order) }
  let!(:eligible_promotion) { create(:promotion, path: path) }
  let!(:promotion) { create(:promotion_with_item_total_rule, path: 'qwe') }
  let(:subject) { described_class.new }

  describe '#call' do
    it 'returns promotion that should be applied' do
      result = subject.call(order: order, path: path)
      expect(result.success?).to eq(true)
      expect(result.value[:promotion].id).to eq(eligible_promotion.id)
    end

    it 'fails on non existing promotion' do
      result = subject.call(order: order, path: 'non_existing_path')
      expect(result.success?).to eq(false)
      expect(result.value).to eq(:promotion_not_found)
    end

    context 'without promotions' do
      it 'doesnt raise any exception' do
        result = subject.call(order: order, promotion: promotion, path: 'qwe')
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:order_not_eligible_for_promotion)
      end
    end
  end
end
