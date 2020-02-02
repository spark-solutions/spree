module Spree
  class V2::Platform::PromotionRuleSerializer
    include FastJsonapi::ObjectSerializer
    attributes :type, :created_at, :updated_at, :code, :preferences
  end
end
