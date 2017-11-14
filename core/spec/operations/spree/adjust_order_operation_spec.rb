require 'spec_helper'

describe Spree::AdjustOrderOperation do
  let(:label) { 'label' }
  let(:order) { create(:order_with_line_items) }
  let(:promotion) { create(:promotion) }
  let(:action) { Spree::Promotion::Actions::CreateAdjustment.new(calculator: calculator) }
  let(:calculator) { Spree::Calculator::FlatRate.new(preferred_amount: 10) }
  let(:payload) { { order: order, adjustable: order, adjustment_source: action, label: label  } }
  let(:subject) { described_class.new }

  describe '#call' do
    context 'with eligible promotion' do
      it 'it adds promotion to order' do
        result = subject.call(payload)
        debugger
        expect(result.success?).to eq(true)
        expect(order.adjustments.count).to eq(1)
      end
    end

    context 'with missing label' do
      let(:label) { nil }
      it 'doesnt add promotion to order' do
        result = subject.call(payload)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:adjustment_not_created)
        expect(order.adjustments.count).to eq(0)
      end
    end

    context 'with adjustment equal 0' do
      let(:calculator) { Spree::Calculator::FlatRate.new(preferred_amount: 0) }
      it 'doesnt add promotion to order' do
        result = subject.call(payload)
        expect(result.success?).to eq(false)
        expect(result.value).to eq(:amount_equal_zero)
        expect(order.adjustments.count).to eq(0)
      end
    end
  end
end
