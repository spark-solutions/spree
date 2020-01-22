require 'spec_helper'

describe 'Switching currencies in backend', type: :feature do
  let(:mug) { create(:base_product, name: 'RoR Mug') }
  let(:store) { Spree::Store.default }

  # Regression test for #2340
  it 'does not cause current_order to become nil', inaccessible: true, js: true do
    add_to_cart(mug)
    # Now that we have an order...
    store.update!(default_currency: 'AUD')
    expect { visit spree.root_path }.not_to raise_error
  end
end
