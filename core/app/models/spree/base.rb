class Spree::Base < ApplicationRecord
  include Spree::Preferences::Preferable
  self.abstract_class = true

   # if ActiveRecord::Base.connection.native_database_types[:json] == nil

  include Spree::RansackableAttributes

  after_initialize do
    if has_attribute?(:json_preferences)
      self.json_preferences = JSON.dump(default_preferences.merge(preferences))
    end
  end

  def preferences
    @preferences ||= if !self.read_attribute(:json_preferences).nil?
                      JSON.parse(self.read_attribute(:json_preferences))
                    else
                      return {} if self.read_attribute(:preferences).nil?
                      YAML.load(self.read_attribute(:preferences))
                    end
  end

  if Kaminari.config.page_method_name != :page
    def self.page(num)
      send Kaminari.config.page_method_name, num
    end
  end

  def self.belongs_to_required_by_default
    false
  end

  def self.spree_base_scopes
    where(nil)
  end
end
