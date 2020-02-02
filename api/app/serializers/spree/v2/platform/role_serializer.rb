module Spree
  class V2::Platform::RoleSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name
  end
end
