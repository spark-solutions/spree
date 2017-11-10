require 'spec_helper'

describe Spree::PagePromotion::Fetch do
  let(:path) { 'some_path' }
  let!(:order) { create(:order) }
  let!(:promotion) { create(:promotion, path: path) }
  let(:subject) { described_class.new }

  describe '#call' do
    it 'returns promotion that should be applied' do
      result = subject.call(path: path)
      expect(result.success?).to eq(true)
      expect(result.value[:promotion].id).to eq(promotion.id)
    end

    it 'fails on non existing promotion' do
      result = subject.call(path: 'non_existing_path')
      expect(result.success?).to eq(false)
      expect(result.value).to eq(:promotion_not_found)
    end
  end
end
