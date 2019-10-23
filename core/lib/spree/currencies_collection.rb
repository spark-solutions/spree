module Spree
  class CurrenciesCollection < Array
    def initialize(array)
      super(array.map(&:to_s).map do |el|
        return el if el.is_a?(::Money::Currency)
        ::Money::Currency.find(el.strip)
      end.uniq.compact)
    end

    def by_iso(iso)
      find { |currency| currency.iso_code == iso }
    end

    def multiple?
      size > 1
    end
  end
end