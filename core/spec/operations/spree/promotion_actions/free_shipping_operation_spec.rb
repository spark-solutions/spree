require 'spec_helper'

describe Spree::PromotionActions::FreeShippingOperation do
  let(:order) { create(:order_with_line_items, line_items_count: 1) }
  let(:promotion) { create(:promotion) }
  let(:action) { Spree::Promotion::Actions::FreeShipping.new(promotion: promotion) }
  let(:payload) { { order: order, adjustable: order, adjustment_source: action, label: 'label'  } }
  let(:subject) { described_class.new }

  describe '#call' do
    it 'adds adjustment to order' do
      result = subject.call(payload)
      expect(result.success?).to eq(true)
      expect(order.shipments.first.adjustments.count).to eq(1)
    end

    context 'with order without shipments' do
      it 'doesnt add adjustment to order' do
        order.shipments.destroy_all
        result = subject.call(payload)
        expect(result.success?).to eq(false)
      end
    end
  end
end
