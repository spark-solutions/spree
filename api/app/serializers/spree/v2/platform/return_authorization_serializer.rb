module Spree
  class V2::Platform::ReturnAuthorizationSerializer
    include FastJsonapi::ObjectSerializer
    attributes :number, :state, :memo, :created_at, :updated_at
  end
end
