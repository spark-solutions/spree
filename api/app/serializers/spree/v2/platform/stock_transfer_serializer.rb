module Spree
  class V2::Platform::StockTransferSerializer
    include FastJsonapi::ObjectSerializer
    attributes :type, :reference, :created_at, :updated_at, :number
  end
end
