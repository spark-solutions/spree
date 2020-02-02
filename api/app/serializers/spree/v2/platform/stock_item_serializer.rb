module Spree
  class V2::Platform::StockItemSerializer
    include FastJsonapi::ObjectSerializer
    attributes :count_on_hand, :created_at, :updated_at, :backorderable, :deleted_at
  end
end
