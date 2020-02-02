module Spree
  class V2::Platform::StockMovementSerializer
    include FastJsonapi::ObjectSerializer
    attributes :quantity, :action, :created_at, :updated_at, :originator_type
  end
end
