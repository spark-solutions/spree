module Spree
  class V2::Platform::ProductSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :description, :available_on, :deleted_at, :slug, :meta_description, :meta_keywords, :created_at, :updated_at, :promotionable, :meta_title, :discontinue_on
  end
end
