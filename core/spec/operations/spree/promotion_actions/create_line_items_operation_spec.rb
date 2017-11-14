require 'spec_helper'

describe Spree::PromotionActions::AddLineItemsOperation, type: :operation do
  let(:order) { create(:order) }
  let(:action) { Spree::Promotion::Actions::CreateLineItems.create(promotion: promotion) }
  let(:promotion) { create(:promotion) }
  let(:shirt) { create(:variant) }
  let(:mug) { create(:variant) }
  let(:payload) { { order: order, line_items: action.promotion_action_line_items, adjustment_source: action, label: 'label'  } }
  let(:subject) { described_class.new }

  def empty_stock(variant)
    variant.stock_items.update_all(backorderable: false)
    variant.stock_items.each(&:reduce_count_on_hand_to_zero)
  end

  context '#call' do
    before do
      action.promotion_action_line_items.create!(
        variant: mug,
        quantity: 1
      )
      action.promotion_action_line_items.create!(
        variant: shirt,
        quantity: 2
      )
    end

    context 'order is eligible' do
      it 'adds line items to order with correct variant and quantity' do
        subject.call(payload)
        expect(order.line_items.count).to eq(2)
        line_item = order.line_items.find_by(variant_id: mug.id)
        expect(line_item).not_to be_nil
        expect(line_item.quantity).to eq(1)
      end

      it 'only adds the delta of quantity to an order' do
        order.contents.add(shirt, 1)
        subject.call(payload)
        line_item = order.line_items.find_by(variant_id: shirt.id)
        expect(line_item).not_to be_nil
        expect(line_item.quantity).to eq(2)
      end

      it "doesn't add if the quantity is greater" do
        order.contents.add(shirt, 3)
        subject.call(payload)
        line_item = order.line_items.find_by(variant_id: shirt.id)
        expect(line_item).not_to be_nil
        expect(line_item.quantity).to eq(3)
      end

      it "doesn't try to add an item if it's out of stock" do
        empty_stock(mug)
        empty_stock(shirt)

        expect(order.contents).to_not receive(:add)
        subject.call(payload)
      end
    end
  end
end
