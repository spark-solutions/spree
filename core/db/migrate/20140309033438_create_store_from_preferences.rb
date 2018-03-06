class CreateStoreFromPreferences < ActiveRecord::Migration

  # workaround for spree_i18n and Store translations
  # Spree::Store.reset_column_information doesnt work as expected
  class Store < Spree::Base
    self.table_name = 'spree_stores'
    def self.translated?(name)
      false
    end
  end

  def change
    preference_store = Spree::Preferences::Store.instance
    if store = Store.where(default: true).first
      store.meta_description = preference_store.get('spree/app_configuration/default_meta_description') {}
      store.meta_keywords    = preference_store.get('spree/app_configuration/default_meta_keywords') {}
      store.seo_title        = preference_store.get('spree/app_configuration/default_seo_title') {}
      store.save!
    else
      # we set defaults for the things we now require
      Store.new do |s|
        s.name              = preference_store.get 'spree/app_configuration/site_name' do
          'Spree Demo Site'
        end
        s.url               = preference_store.get 'spree/app_configuration/site_url' do
          'demo.spreecommerce.com'
        end
        s.mail_from_address = preference_store.get 'spree/app_configuration/mails_from' do
          'spree@example.com'
        end

        s.meta_description = preference_store.get('spree/app_configuration/default_meta_description') {}
        s.meta_keywords    = preference_store.get('spree/app_configuration/default_meta_keywords') {}
        s.seo_title        = preference_store.get('spree/app_configuration/default_seo_title') {}
        s.default_currency = preference_store.get('spree/app_configuration/currency') {}
        s.code             = 'spree'
      end.save!
    end
  end
end
