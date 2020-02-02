module Spree
  class V2::Platform::CustomerReturnSerializer
    include FastJsonapi::ObjectSerializer
    attributes :number, :created_at, :updated_at
  end
end
