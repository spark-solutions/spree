class Spree::Base < ApplicationRecord
  include Spree::Preferences::Preferable
  serialize :preferences, JSON if ActiveRecord::Base.connection.native_database_types[:json] == nil

  include Spree::RansackableAttributes

  after_initialize do
    if has_attribute?(:preferences) && !preferences.nil?

      # czy tu przestawiamy się w 100% na json czy nie?
      
      if ActiveRecord::Base.connection.native_database_types[:json] == nil
        self.preferences = default_preferences.merge(preferences)
      else
        self.json_preferences = default_preferences.merge(preferences)
      end
    end
  end

  if Kaminari.config.page_method_name != :page
    def self.page(num)
      send Kaminari.config.page_method_name, num
    end
  end

  self.abstract_class = true

  def self.belongs_to_required_by_default
    false
  end

  def self.spree_base_scopes
    where(nil)
  end
end
