require 'spec_helper'

describe 'Updating currencies settings', type: :feature, js: true do
  let!(:store) { create(:store, default: true) }
  stub_authorization!

  before do
    reset_spree_preferences do |config|
      config.allow_currency_change = false
      config.show_currency_selector = false
    end
  end

  it 'allows to update supported currencies' do
    visit spree.edit_admin_general_settings_path

    # Test initial state
    expect(page).to have_unchecked_field('allow_currency_change')
    expect(page).to have_unchecked_field('show_currency_selector')

    # Interact with the form
    check('allow_currency_change')
    check('show_currency_selector')
    click_button 'Update'

    # Test final state
    expect(page).to have_content 'General Settings has been successfully updated!'
    expect(page).to have_checked_field('allow_currency_change')
    expect(page).to have_checked_field('show_currency_selector')
  end
end
