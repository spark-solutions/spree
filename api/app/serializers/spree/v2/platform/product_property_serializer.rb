module Spree
  class V2::Platform::ProductPropertySerializer
    include FastJsonapi::ObjectSerializer
    attributes :value, :created_at, :updated_at, :position
  end
end
