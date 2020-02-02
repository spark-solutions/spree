module Spree
  class V2::Platform::StateChangeSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :previous_state, :stateful_type, :next_state, :created_at, :updated_at
  end
end
