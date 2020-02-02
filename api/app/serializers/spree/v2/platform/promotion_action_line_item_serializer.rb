module Spree
  class V2::Platform::PromotionActionLineItemSerializer
    include FastJsonapi::ObjectSerializer
    attributes :quantity
  end
end
