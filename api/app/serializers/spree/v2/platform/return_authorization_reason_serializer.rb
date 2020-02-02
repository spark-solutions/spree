module Spree
  class V2::Platform::ReturnAuthorizationReasonSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :active, :mutable, :created_at, :updated_at
  end
end
