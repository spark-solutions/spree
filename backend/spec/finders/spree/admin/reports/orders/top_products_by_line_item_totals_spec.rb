
require 'spec_helper'

describe Spree::Admin::Reports::Orders::TopProductsByLineItemTotals do
  subject do
    described_class.new(
      date_from: date_from,
      date_to: date_to,
      top: top
    )
  end

  let(:date_from) { nil }
  let(:date_to) { nil }
  let(:top) { nil }

  let!(:order1) { create(:completed_order_with_totals) }
  let!(:order2) { create(:completed_order_with_totals) }
  let!(:order3) { create(:completed_order_with_totals) }

  let(:product1) { create(:product, price: 10) }
  let(:product2) { create(:product, price: 20) }

  let(:variant1) { create(:variant, product: product1, price: 90)}

  before do
    order1.line_items.first.update(quantity: 3, variant: product1.master)
    order2.line_items.first.update(quantity: 2, variant: variant1)
    order3.line_items.first.update(quantity: 1, variant: product2.master)

    order1.line_items.each { |li| li.update_price; li.save! }
    order2.line_items.each { |li| li.update_price; li.save! }
    order3.line_items.each { |li| li.update_price; li.save! }
  end

  context 'when the date range is not present' do
    it 'returns a report from last 7 days' do
      order1.update!(completed_at: '2019-01-13')
      order2.update!(completed_at: '2019-02-13')
      order3.update!(completed_at: '2019-02-14')

      Timecop.freeze(2019, 02, 20) do
        array = subject.call

        expect(array).to eq [
          [variant1.descriptive_name, 180],
          [product2.master.descriptive_name, 20]
        ]
      end
    end
  end

  context 'when the date range is valid' do
    context 'when date range includes all the orders' do
      let(:date_from) { '2016-01-01' }
      let(:date_to) { '2019-01-01' }

      it 'returns top product grouped by product SKU' do
        order1.update!(completed_at: '2016-12-12')
        order2.update!(completed_at: '2018-12-12')
        order3.update!(completed_at: '2018-12-12')

        array = subject.call

        expect(array).to eq [
          [variant1.descriptive_name, 180],
          [product1.master.descriptive_name, 30],
          [product2.master.descriptive_name, 20]
        ]
      end
    end

    context 'when date range includes only part of all orders' do
      let(:date_from) { '2017-01-01' }
      let(:date_to) { '2019-01-01' }

      it 'returns top products grouped by product SKU' do
        order1.update!(completed_at: '2016-12-12')
        order2.update!(completed_at: '2018-12-12')
        order3.update!(completed_at: '2018-12-12')

        array = subject.call

        expect(array).to eq [
          [variant1.descriptive_name, 180],
          [product2.master.descriptive_name, 20]
        ]
      end
    end
  end

  context 'when top param is present' do
    let(:top) { 1 }

    it 'returns results for given top param' do
      order1.update!(completed_at: '2019-02-16')
      order2.update!(completed_at: '2019-02-17')
      order3.update!(completed_at: '2019-02-18')

      Timecop.freeze(2019, 02, 20) do
        array = subject.call

        expect(array).to eq [
          [variant1.descriptive_name, 180]
        ]
      end
    end
  end
end
