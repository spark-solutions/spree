module Spree
  class V2::Platform::PaymentSerializer
    include FastJsonapi::ObjectSerializer
    attributes :amount, :source_type, :state, :response_code, :avs_response, :created_at, :updated_at, :number, :cvv_response_code, :cvv_response_message
  end
end
