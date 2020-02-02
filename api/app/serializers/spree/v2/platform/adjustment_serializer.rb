module Spree
  class V2::Platform::AdjustmentSerializer
    include FastJsonapi::ObjectSerializer
    attributes :source_type, :adjustable_type, :amount, :label, :mandatory, :eligible, :created_at, :updated_at, :state, :included
  end
end
