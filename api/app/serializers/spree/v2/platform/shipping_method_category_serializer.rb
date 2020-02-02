module Spree
  class V2::Platform::ShippingMethodCategorySerializer
    include FastJsonapi::ObjectSerializer
    attributes :created_at, :updated_at
  end
end
