module Spree
  class V2::Platform::PromotionSerializer
    include FastJsonapi::ObjectSerializer
    attributes :description, :expires_at, :starts_at, :name, :type, :usage_limit, :match_policy, :code, :advertise, :path, :created_at, :updated_at
  end
end
