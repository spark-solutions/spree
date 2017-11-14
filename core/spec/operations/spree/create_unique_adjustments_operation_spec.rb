require 'spec_helper'

describe Spree::ApplyItemsAdjustmentsOperation do
  let(:order) { create(:order_with_line_items) }
  let(:promotion) { create(:promotion_with_order_adjustment) }
  let!(:action) { Spree::Promotion::Actions::CreateItemAdjustments.create(promotion: promotion, calculator: calculator) }
  let(:calculator) { Spree::Calculator::FlatRate.new(preferred_amount: 10) }
  let(:subject) { described_class.new }

  describe '#call' do
    it 'it adds promotion to order' do
      result = subject.call(order: order, label: 'Promo', adjustables: order.line_items, adjustment_source: action)
      expect(result.success?).to eq(true)
      expect(order.line_items.first.adjustments.count).to eq(1)
    end

    it 'doesnt add same action twice' do
      subject.call(order: order, label: 'Promo', adjustables: order.line_items, adjustment_source: action)
      result = subject.call(order: order, label: 'Promo', adjustables: order.line_items, adjustment_source: action)
      expect(result.success?).to eq(false)
      expect(order.line_items.first.adjustments.count).to eq(1)
    end
  end
end
