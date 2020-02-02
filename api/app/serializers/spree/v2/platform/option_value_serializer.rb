module Spree
  class V2::Platform::OptionValueSerializer
    include FastJsonapi::ObjectSerializer
    attributes :position, :name, :presentation, :created_at, :updated_at
  end
end
