module Spree
  class V2::Platform::ProductOptionTypeSerializer
    include FastJsonapi::ObjectSerializer
    attributes :position, :created_at, :updated_at
  end
end
