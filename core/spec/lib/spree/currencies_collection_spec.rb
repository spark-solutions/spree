require 'spec_helper'

describe Spree::CurrenciesCollection do
  let(:currencies) { %w(EUR USD GBP) }
  let(:collection) { described_class.new(currencies) }
  describe '.initialize' do
    it 'initialize collection with money objects' do
      expect(collection).to contain_exactly(
        ::Money::Currency.find('EUR'), ::Money::Currency.find('USD'), 
        ::Money::Currency.find('GBP')
      )
    end
  end

  describe '.by_iso' do
    it 'returns correct money object' do
      expect(collection.by_iso('USD')).to eq(::Money::Currency.find('USD'))
    end
  end

  describe '.multiple?' do
    it 'returns true' do
      expect(collection.multiple?).to be true
    end
  end
end
