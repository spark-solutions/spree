module Spree
  module Api
    class ErrorsController < ActionController::API
      protect_from_forgery

      def render_404
        render 'spree/api/errors/not_found', status: 404
      end
    end
  end
end
