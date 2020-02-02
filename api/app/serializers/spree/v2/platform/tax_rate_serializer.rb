module Spree
  class V2::Platform::TaxRateSerializer
    include FastJsonapi::ObjectSerializer
    attributes :amount, :included_in_price, :created_at, :updated_at, :name, :show_rate_in_label, :deleted_at
  end
end
