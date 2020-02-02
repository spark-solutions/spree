module Spree
  class V2::Platform::ClassificationSerializer
    include FastJsonapi::ObjectSerializer
    attributes :position
  end
end
