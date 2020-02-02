module Spree
  class V2::Platform::PaymentCaptureEventSerializer
    include FastJsonapi::ObjectSerializer
    attributes :amount, :created_at, :updated_at
  end
end
