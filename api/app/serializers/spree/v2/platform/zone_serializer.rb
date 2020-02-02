module Spree
  class V2::Platform::ZoneSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :description, :default_tax, :zone_members_count, :created_at, :updated_at, :kind
  end
end
