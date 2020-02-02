module Spree
  class V2::Platform::StockLocationSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :created_at, :updated_at, :default, :address1, :address2, :city, :state_name, :zipcode, :phone, :active, :backorderable_default, :propagate_all_variants, :admin_name
  end
end
