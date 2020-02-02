module Spree
  class V2::Platform::CreditCardSerializer
    include FastJsonapi::ObjectSerializer
    attributes :month, :year, :cc_type, :last_digits, :created_at, :updated_at, :name, :default, :deleted_at
  end
end
