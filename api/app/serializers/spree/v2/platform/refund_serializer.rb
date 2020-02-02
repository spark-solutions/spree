module Spree
  class V2::Platform::RefundSerializer
    include FastJsonapi::ObjectSerializer
    attributes :amount, :created_at, :updated_at
  end
end
