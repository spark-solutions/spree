module Spree
  class V2::Platform::LineItemSerializer
    include FastJsonapi::ObjectSerializer
    attributes :quantity, :price, :created_at, :updated_at, :currency, :cost_price, :adjustment_total, :additional_tax_total, :promo_total, :included_tax_total, :pre_tax_amount, :taxable_adjustment_total, :non_taxable_adjustment_total
  end
end
