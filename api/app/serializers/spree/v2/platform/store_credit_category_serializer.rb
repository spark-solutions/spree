module Spree
  class V2::Platform::StoreCreditCategorySerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :created_at, :updated_at
  end
end
