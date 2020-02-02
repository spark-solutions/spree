module Spree
  class V2::Platform::ShippingCategorySerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :created_at, :updated_at
  end
end
