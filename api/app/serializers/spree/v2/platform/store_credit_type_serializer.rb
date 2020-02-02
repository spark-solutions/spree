module Spree
  class V2::Platform::StoreCreditTypeSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :priority, :created_at, :updated_at
  end
end
