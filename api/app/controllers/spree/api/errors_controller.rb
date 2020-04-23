module Spree
  module Api
    class ErrorsController < ActionController::Base
      protect_from_forgery

      def render_404
        render 'spree/api/errors/not_found', status: 404
      end
    end
  end
end
