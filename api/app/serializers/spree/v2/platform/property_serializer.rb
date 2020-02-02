module Spree
  class V2::Platform::PropertySerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :presentation, :created_at, :updated_at
  end
end
