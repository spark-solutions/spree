module Spree
  class V2::Platform::TaxonomySerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :created_at, :updated_at, :position
  end
end
