module Spree
  class V2::Platform::PreferenceSerializer
    include FastJsonapi::ObjectSerializer
    attributes :value, :key, :created_at, :updated_at
  end
end
