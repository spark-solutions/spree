require 'spec_helper'

describe Spree::DeactivatePromotionOperation do
  let(:order) { create(:order) }
  let(:promotion) { create(:promotion) }
  let!(:action) { Spree::Promotion::Actions::CreateLineItems.create!(promotion: promotion) }
  let(:subject) { described_class.new }
  let(:mug) { create(:variant) }


  describe '#call' do
    context 'with eligible promotion' do
      before do
        action.promotion_action_line_items.create!(
          variant: mug,
          quantity: 1
        )
        Spree::ActivatePromotionOperation.new.call(order: order, promotion: promotion)
      end
      it 'it adds promotion to order' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(true)
      end
    end

    context 'with non revertible action' do
      let!(:action) { Spree::Promotion::Actions::CreateAdjustment.create!(promotion: promotion) }
      before { Spree::ActivatePromotionOperation.new.call(order: order, promotion: promotion) }

      it 'doesnt do anything' do
        result = subject.call(order: order, promotion: promotion)
        expect(result.success?).to eq(false)
      end
    end
  end
end
