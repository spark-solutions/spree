require 'spec_helper'

describe Spree::CartPromotion::Activator do
  let(:order) { create(:order_with_line_items) }
  let(:promotion) { create(:promotion_with_item_total_rule) }
  let(:eligible_promotion) { create(:promotion_with_order_adjustment) }
  let(:subject) { Spree::CartPromotion::Activator.new }

  describe '#call' do
    context 'with eligible promotion' do
      it 'it adds promotion to order' do
        subject.call(order: order, promotions: [eligible_promotion])
        expect(eligible_promotion.orders).to contain_exactly(order)
      end
    end

    context 'with not eligible promotion' do
      it 'doesnt add promotion to order' do
        subject.call(order: order, promotions: [promotion])
        expect(promotion.orders).to eq([])
      end
    end

    context 'without promotions' do
      it 'doesnt raise any exception' do
        result = subject.call(order: order, promotions: [])
        expect(result.success?).to eq(true)
      end
    end
  end
end
