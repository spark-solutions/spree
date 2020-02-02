module Spree
  class V2::Platform::ShippingCalculatorSerializer
    include FastJsonapi::ObjectSerializer
    attributes :type, :calculable_type, :created_at, :updated_at, :preferences, :deleted_at
  end
end
