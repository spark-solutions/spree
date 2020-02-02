module Spree
  class V2::Platform::CountrySerializer
    include FastJsonapi::ObjectSerializer
    attributes :iso_name, :iso, :iso3, :name, :numcode, :states_required, :updated_at, :zipcode_required
  end
end
