module Spree
  class V2::Platform::OptionTypeSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :presentation, :position, :created_at, :updated_at
  end
end
