module Spree
  class V2::Platform::ReimbursementTypeSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :active, :mutable, :created_at, :updated_at, :type
  end
end
