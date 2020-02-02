module Spree
  class V2::Platform::StoreSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :url, :meta_description, :meta_keywords, :seo_title, :mail_from_address, :default_currency, :code, :default, :created_at, :updated_at, :facebook, :twitter, :instagram
  end
end
