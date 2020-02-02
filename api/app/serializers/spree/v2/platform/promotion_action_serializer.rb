module Spree
  class V2::Platform::PromotionActionSerializer
    include FastJsonapi::ObjectSerializer
    attributes :position, :type, :deleted_at
  end
end
