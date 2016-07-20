module Spree
  module Core
    module ControllerHelpers
      module Search
        def build_searcher(params)
          Spree::Config.searcher_class.new(search_params(params)).tap do |searcher|
            searcher.current_user = try_spree_current_user
            searcher.current_currency = current_currency
          end
        end

        private

        def search_params(params)
          params.is_a?(ActionController::Parameters) ? params.to_unsafe_h : params
        end
      end
    end
  end
end
