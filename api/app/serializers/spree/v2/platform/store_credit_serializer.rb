module Spree
  class V2::Platform::StoreCreditSerializer
    include FastJsonapi::ObjectSerializer
    attributes :amount, :amount_used, :memo, :deleted_at, :currency, :amount_authorized, :originator_type, :created_at, :updated_at
  end
end
