module Spree
  module Currency
    class FindDefault
      def execute
        Spree::Currency::FindByStore.new.execute
      end
    end
  end
end
