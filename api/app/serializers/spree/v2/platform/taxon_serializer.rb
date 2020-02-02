module Spree
  class V2::Platform::TaxonSerializer
    include FastJsonapi::ObjectSerializer
    attributes :position, :name, :permalink, :lft, :rgt, :description, :created_at, :updated_at, :meta_title, :meta_description, :meta_keywords, :depth
  end
end
