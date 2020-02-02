module Spree
  class V2::Platform::PriceSerializer
    include FastJsonapi::ObjectSerializer
    attributes :amount, :currency, :deleted_at, :created_at, :updated_at
  end
end
