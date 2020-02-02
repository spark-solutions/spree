module Spree
  class V2::Platform::PrototypeSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :created_at, :updated_at
  end
end
