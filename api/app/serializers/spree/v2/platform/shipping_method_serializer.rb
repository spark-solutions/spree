module Spree
  class V2::Platform::ShippingMethodSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :display_on, :deleted_at, :created_at, :updated_at, :tracking_url, :admin_name, :code
  end
end
