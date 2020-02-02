module Spree
  class V2::Platform::StateSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :abbr, :updated_at
  end
end
