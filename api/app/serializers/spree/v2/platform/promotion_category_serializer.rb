module Spree
  class V2::Platform::PromotionCategorySerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :created_at, :updated_at, :code
  end
end
