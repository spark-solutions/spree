module Spree
  class V2::Platform::TaxonImageSerializer
    include FastJsonapi::ObjectSerializer
    attributes :viewable_type, :attachment_width, :attachment_height, :attachment_file_size, :position, :attachment_content_type, :attachment_file_name, :type, :attachment_updated_at, :alt, :created_at, :updated_at
  end
end
