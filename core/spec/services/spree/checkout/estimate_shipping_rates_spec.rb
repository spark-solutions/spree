require 'spec_helper'

module Spree
  describe Checkout::EstimateShippingRates do
    subject { described_class }

    let(:america) { create :country }
    let(:canada)  { create :country, name: 'Canada', iso_name: 'CANADA', iso: 'CA', iso3: 'CAN', numcode: '124' }

    let!(:order) { Spree::Order.create }
    let(:line_item) { create(:line_item, order: order) }
    let(:country_iso) { nil }
    let(:result) { subject.call(order: order, country_iso: country_iso) }
    let(:returned_shipping_methods) { result.value.map(&:shipping_method) }

    let!(:us_zone) { create(:zone, name: 'US') }
    let!(:ca_zone) { create(:zone, name: 'Canada') }

    let!(:ca_shipping_method) { create(:shipping_method, name: 'Canada Post') }
    let!(:us_shipping_method) { create(:shipping_method, name: 'USPS') }

    let(:canadian_address) { create(:address, country: canada, zipcode: 'K1A 0B1') }

    before do
      Spree::Config[:default_country_id] = america.id
      us_zone.countries << america
      ca_zone.countries << canada
      us_shipping_method.zones = [us_zone]
      ca_shipping_method.zones = [ca_zone]
    end

    shared_examples 'returns shipping rates' do
      it 'returns non-empty array' do
        expect(result.success).to eq(true)
        expect(result.value).to be_a Array
        expect(result.value).not_to be_empty
      end
    end

    shared_examples 'canadian shipping rates' do
      it_behaves_like 'returns shipping rates'

      it 'returns Canadian shipping methods' do
        expect(returned_shipping_methods).to include(ca_shipping_method)
        expect(returned_shipping_methods).not_to include(us_shipping_method)
      end
    end

    shared_examples 'US shipping rates' do
      it_behaves_like 'returns shipping rates'

      it 'returns US shipping methods' do
        expect(returned_shipping_methods).not_to include(ca_shipping_method)
        expect(returned_shipping_methods).to include(us_shipping_method)
      end
    end

    context 'without line items' do
      it 'returns an empty array' do
        expect(result.success).to eq(true)
        expect(result.value).to be_a Array
        expect(result.value).to be_empty
      end
    end

    context 'with line items' do
      before { line_item }

      context 'with shipping address' do
        before do
          order.ship_address = canadian_address
          order.save!
        end

        context 'with country ISO passed as param' do
          let(:country_iso) { 'US' }

          it_behaves_like 'US shipping rates'
        end

        context 'without country ISO passed as param' do
          it_behaves_like 'canadian shipping rates'
        end
      end

      context 'without shipping address' do
        context 'with country ISO passed as param' do
          context 'with existing country' do
            let(:country_iso) { 'CA' }

            it_behaves_like 'canadian shipping rates'
          end

          context 'with non-existing country' do
            let(:country_iso) { 'XX' }

            it_behaves_like 'US shipping rates'
          end
        end

        context 'without country ISO passed as param' do
          it_behaves_like 'US shipping rates'
        end
      end
    end
  end
end
