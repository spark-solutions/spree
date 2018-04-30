class AddJsonPreferencesColumns < ActiveRecord::Migration[5.1]
  def change
    json_present = ActiveRecord::Base.connection.native_database_types[:json]

    if json_present
      add_column :spree_calculators, :json_preferences, :json
      add_column :spree_gateways, :json_preferences, :json
      add_column :spree_payment_methods, :json_preferences, :json
      add_column :spree_promotion_rules, :json_preferences, :json
    else
      add_column :spree_calculators, :json_preferences, :text
      add_column :spree_gateways, :json_preferences, :text
      add_column :spree_payment_methods, :json_preferences, :text
      add_column :spree_promotion_rules, :json_preferences, :text
    end
  end
end
