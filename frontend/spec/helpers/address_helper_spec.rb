require 'spec_helper'

describe Spree::AddressesHelper, type: :helper do
  describe '#user_available_addresses' do
    subject        { user_available_addresses }

    let!(:user)    { create(:user) }
    let(:new_york) { create(:state, name: 'New York') }

    let!(:united_states) do
      create(:country, name: 'United States').tap do |usa|
        usa.states << new_york
      end
    end

    let!(:address_1) do
      create(:address,
             country_id: united_states.id,
             state_id: new_york.id,
             user: user)
    end

    let!(:store) { create(:store) }

    before do
      allow_any_instance_of(described_class).to receive(:current_store).and_return(store)
    end

    context 'when user is not present' do
      before do
        allow_any_instance_of(described_class).to receive(:try_spree_current_user).and_return(nil)
      end

      it 'returns an empty array' do
        expect(subject).to match_array []
      end
    end

    context 'when user is present' do
      before do
        allow_any_instance_of(described_class).to receive(:try_spree_current_user).and_return(user)
      end

      context 'when checkout zone does not include user addresses states' do
        before do
          store.update(checkout_zone: create(:zone, kind: :country))
        end

        it 'returns an empty array' do
          expect(subject).to match_array []
        end
      end

      context 'when checkout zone includes user addresses states' do # Global Zone
        before do
          store.update(checkout_zone: create(:global_zone))
        end

        it 'returns that addresses' do
          expect(subject).to match_array address_1
        end
      end
    end
  end
end
