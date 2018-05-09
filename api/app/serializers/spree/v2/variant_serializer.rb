module Spree
  module V2
    class VariantSerializer < BaseSerializer
      set_type :variant
      attributes :name, :sku, :price, :weight, :height, :width, :depth, :is_master,
                :slug, :description, :track_inventory
    end
  end
end
