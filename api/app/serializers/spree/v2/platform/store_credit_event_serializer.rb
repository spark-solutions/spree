module Spree
  class V2::Platform::StoreCreditEventSerializer
    include FastJsonapi::ObjectSerializer
    attributes :action, :amount, :authorization_code, :user_total_amount, :originator_type, :deleted_at, :created_at, :updated_at
  end
end
