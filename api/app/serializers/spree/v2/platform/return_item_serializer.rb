module Spree
  class V2::Platform::ReturnItemSerializer
    include FastJsonapi::ObjectSerializer
    attributes :created_at, :updated_at, :pre_tax_amount, :included_tax_total, :additional_tax_total, :reception_status, :acceptance_status, :acceptance_status_errors, :resellable
  end
end
