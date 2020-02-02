module Spree
  class V2::Platform::ShippingRateSerializer
    include FastJsonapi::ObjectSerializer
    attributes :selected, :cost, :created_at, :updated_at
  end
end
