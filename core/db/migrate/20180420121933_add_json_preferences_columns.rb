class AddJsonPreferencesColumns < ActiveRecord::Migration[5.1]
  def change
    adapter = ActiveRecord::Base.connection.adapter_name.downcase.to_sym

    # adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    # change to ActiveRecord::Base.connection.native_database_types[:json]

    case adapter
    when :sqlite
      add_column :spree_calculators, :json_preferences, :text
      add_column :spree_gateways, :json_preferences, :text
      add_column :spree_payment_methods, :json_preferences, :text
      add_column :spree_promotion_rules, :json_preferences, :text
    when :mysql, :mysql2
      add_column :spree_calculators, :json_preferences, :json
      add_column :spree_gateways, :json_preferences, :json
      add_column :spree_payment_methods, :json_preferences, :json
      add_column :spree_promotion_rules, :json_preferences, :json
    when :postgresql
      add_column :spree_calculators, :json_preferences, :jsonb
      add_column :spree_gateways, :json_preferences, :jsonb
      add_column :spree_payment_methods, :json_preferences, :jsonb
      add_column :spree_promotion_rules, :json_preferences, :jsonb
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter}'"
    end
  end
end
