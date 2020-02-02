module Spree
  class V2::Platform::AddressSerializer
    include FastJsonapi::ObjectSerializer
    attributes :firstname, :lastname, :address1, :address2, :city, :zipcode, :phone, :state_name, :alternative_phone, :company, :created_at, :updated_at, :deleted_at
  end
end
