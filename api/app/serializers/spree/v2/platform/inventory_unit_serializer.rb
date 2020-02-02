module Spree
  class V2::Platform::InventoryUnitSerializer
    include FastJsonapi::ObjectSerializer
    attributes :state, :created_at, :updated_at, :pending, :quantity
  end
end
