module Spree
  class V2::Platform::RefundReasonSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :active, :mutable, :created_at, :updated_at
  end
end
