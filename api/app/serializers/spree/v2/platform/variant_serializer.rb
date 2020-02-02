module Spree
  class V2::Platform::VariantSerializer
    include FastJsonapi::ObjectSerializer
    attributes :sku, :weight, :height, :width, :depth, :deleted_at, :is_master, :cost_price, :position, :cost_currency, :track_inventory, :updated_at, :discontinue_on, :created_at
  end
end
