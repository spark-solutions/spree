module Spree
  module Checkout
    class EstimateShippingRates
      prepend Spree::ServiceModule::Base

      def call(order:, country_iso: nil)
        run :create_temporary_order
        run :set_shipping_address
        run :calculate_shipping_rates
      end

      def create_temporary_order(order:, country_iso: nil)
        temp_order = order.dup
        temp_order.line_items = order.line_items
        temp_order.ship_address = order.ship_address

        success(order: temp_order, country_iso: country_iso)
      end

      def set_shipping_address(order:, country_iso: nil)
        if country_iso.present?
          selected_country ||= Spree::Country.find_by(iso: country_iso.upcase)
          selected_country ||= Spree::Country.find_by(iso3: country_iso.upcase)
        end
        selected_country ||= Spree::Country.default

        if order.ship_address.blank? || country_iso.present?
          order.ship_address = Spree::Address.new(country_id: selected_country.id)
        end

        success(order: order, country_iso: nil)
      end

      def calculate_shipping_rates(order:, country_iso:)
        packages = Spree::Stock::Coordinator.new(order).packages
        estimator = Spree::Stock::Estimator.new(order)
        shipping_rates = if order.line_items.any? && packages.any?
          estimator.shipping_rates(packages.first)
        else
          []
        end
        success(shipping_rates)
      end
    end
  end
end
