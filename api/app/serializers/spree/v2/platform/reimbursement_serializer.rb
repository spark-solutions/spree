module Spree
  class V2::Platform::ReimbursementSerializer
    include FastJsonapi::ObjectSerializer
    attributes :number, :reimbursement_status, :total, :created_at, :updated_at
  end
end
