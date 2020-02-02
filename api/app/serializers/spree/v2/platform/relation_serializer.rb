module Spree
  class V2::Platform::RelationSerializer
    include FastJsonapi::ObjectSerializer
    attributes :relatable_type, :related_to_type, :created_at, :updated_at, :discount_amount, :position
  end
end
