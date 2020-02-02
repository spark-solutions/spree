module Spree
  module Api
    module V2
      module Platforrm
        class ResourceController < ::Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers

          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          def show
            render_serialized_payload { serialize_resource(resource) }
          end

          def create
          end

          def update
          end

          def destroy
          end

          private

          def collection_serializer
            Spree::Api::Dependencies.storefront_taxon_serializer.constantize
          end

          def resource_serializer
            Spree::V2::Platform::ResourceSerializer
          end

          def collection_finder
            Spree::Api::Dependencies.storefront_taxon_finder.constantize
          end

          def paginated_collection
            collection_paginator.new(collection, params).call
          end

          def collection
            collection_finder.new(scope: scope, params: params).execute
          end

          def scope
            resource_class.accessible_by(current_ability, :show).includes(scope_includes)
          end

          def scope_includes
            resource_class.reflect_on_all_associations.map(&:name)
          end
        end
      end
    end
  end
end
