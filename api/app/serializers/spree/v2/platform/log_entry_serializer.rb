module Spree
  class V2::Platform::LogEntrySerializer
    include FastJsonapi::ObjectSerializer
    attributes :source_type, :details, :created_at, :updated_at
  end
end
