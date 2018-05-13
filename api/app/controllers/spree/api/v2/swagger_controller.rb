module Spree
  module Api
    module V2
      class SwaggerController < ActionController::API
        def index
          file_path = File.expand_path('../../../../../swagger.yml', __dir__)
          send_file File.open(file_path), type: 'application/x-yaml'
        end
      end
    end
  end
end
