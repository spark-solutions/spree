module Spree
  class V2::Platform::ZoneMemberSerializer
    include FastJsonapi::ObjectSerializer
    attributes :zoneable_type, :created_at, :updated_at
  end
end
