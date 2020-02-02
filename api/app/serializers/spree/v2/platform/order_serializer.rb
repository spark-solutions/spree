module Spree
  class V2::Platform::OrderSerializer
    include FastJsonapi::ObjectSerializer
    attributes :number, :item_total, :total, :state, :adjustment_total, :completed_at, :payment_total, :shipment_state, :payment_state, :email, :special_instructions, :created_at, :updated_at, :currency, :last_ip_address, :shipment_total, :additional_tax_total, :promo_total, :channel, :included_tax_total, :item_count, :approved_at, :confirmation_delivered, :considered_risky, :token, :canceled_at, :state_lock_version, :taxable_adjustment_total, :non_taxable_adjustment_total
  end
end
