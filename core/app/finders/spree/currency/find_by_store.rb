module Spree
  module Currency
    class FindByStore
      def execute(store:)
        store ||= default_store

        store.default_currency || legacy_preference
      end

      private

      def default_store
        Spree::Store.default
      end

      def legacy_preference
        # TODO: add deprecation notice that this will be removed in 4.0
        Spree::Config[:currency]
      end
    end
  end
end
