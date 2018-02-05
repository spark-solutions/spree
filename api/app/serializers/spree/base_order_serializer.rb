module Spree
  class OrderBaseSerializer < ::Spree::BaseSerializer
    attribute :number, :display_ship_total, :display_tax_total, :display_adjustment_total,
              :display_item_total, :total_quantity, :display_total, :token, :id, :number,
              :item_total, :total, :ship_total, :state, :adjustment_total, :canceler_id,
              :user_id, :created_at, :updated_at, :completed_at, :payment_total,
              :shipment_state, :payment_state, :email, :special_instructions, :channel,
              :included_tax_total, :additional_tax_total, :display_included_tax_total,
              :display_additional_tax_total, :tax_total, :currency, :considered_risky,
              :checkout_steps

    # has_many :shipments, ::Spree::ShipmentSerializer
    # has_many :adjustments, ::Spree::AdjustmentSerializer

    has_one :ship_address, ::Spree::AddressSerializer
    has_one :bill_address, ::Spree::AddressSerializer

    def display_item_total(object)
      object.display_item_total.to_s
    end

    def display_total(object)
      object.display_total.to_s
    end

    def total_quantity(object)
      object.line_items.sum(:quantity)
    end

    def token(object)
      object.guest_token
    end
  end
end
