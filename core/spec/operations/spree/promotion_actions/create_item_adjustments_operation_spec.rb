require 'spec_helper'

describe Spree::PromotionActions::CreateItemAdjustmentsOperation do
  let(:order) { create(:order_with_line_items, line_items_count: 1) }
  let(:promotion) { create(:promotion) }
  let(:action) { Spree::Promotion::Actions::CreateItemAdjustments.new(calculator: calculator, promotion: promotion) }
  let(:calculator) { Spree::Calculator::FlatRate.new(preferred_amount: 10) }
  let(:payload) { { order: order, promotion: promotion, adjustment_source: action, label: 'label'  } }
  let(:subject) { described_class.new }

  describe '#call' do
    it 'adds adjustment to order' do
      result = subject.call(payload)
      expect(result.success?).to eq(true)
      expect(order.line_items.first.adjustments.count).to eq(1)
    end

    context 'with adjustment amount equal to 0' do
      let(:calculator) { Spree::Calculator::FlatRate.new(preferred_amount: 0) }

      it 'doesnt add adjustment to order' do
        result = subject.call(payload)
        expect(result.success?).to eq(false)
        expect(order.line_items.first.adjustments.count).to eq(0)
      end
    end
  end
end
