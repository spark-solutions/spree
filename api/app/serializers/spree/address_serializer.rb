module Spree
  class AddressSerializer < ::Spree::BaseSerializer
    attribute :id, :firstname, :lastname, :first_name, :last_name,
              :address1, :address2, :city, :country_id, :state_id,
              :zipcode, :phone, :state_name, :alternative_phone, :company,
              :country, :state
  end
end
