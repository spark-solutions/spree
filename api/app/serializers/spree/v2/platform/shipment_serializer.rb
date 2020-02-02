module Spree
  class V2::Platform::ShipmentSerializer
    include FastJsonapi::ObjectSerializer
    attributes :tracking, :number, :cost, :shipped_at, :state, :created_at, :updated_at, :adjustment_total, :additional_tax_total, :promo_total, :included_tax_total, :pre_tax_amount, :taxable_adjustment_total, :non_taxable_adjustment_total
  end
end
