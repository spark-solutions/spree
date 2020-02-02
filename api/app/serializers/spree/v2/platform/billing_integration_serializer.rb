module Spree
  class V2::Platform::BillingIntegrationSerializer
    include FastJsonapi::ObjectSerializer
    attributes :type, :name, :description, :active, :deleted_at, :created_at, :updated_at, :display_on, :auto_capture, :preferences, :position
  end
end
