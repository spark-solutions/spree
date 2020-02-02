module Spree
  class V2::Platform::TaxCategorySerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :description, :is_default, :deleted_at, :created_at, :updated_at, :tax_code
  end
end
