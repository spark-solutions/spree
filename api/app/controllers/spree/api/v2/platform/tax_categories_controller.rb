module Spree
  module Api
    module V2
      module Platforrm
        class TaxCategoriesController < ResourceController
          private

          def resource_class
            ::Spree::TaxCategory
          end
        end
      end
    end
  end
end
