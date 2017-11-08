require_dependency 'spree/api/controller_setup'

module Spree
  module Api
    module V2
      class BaseController < ActionController::Base
        include Spree::Core::ControllerHelpers::Store
        include Spree::Core::ControllerHelpers::StrongParameters
        include CanCan::ControllerAdditions
        include Spree::Core::ControllerHelpers::Auth

        prepend_view_path Rails.root + 'app/views/spree/api/v2'
        append_view_path File.expand_path('../../../app/views', File.dirname(__FILE__))

        respond_to :json

        attr_accessor :current_api_user

        before_action :set_content_type
        before_action :load_user
        before_action :authorize_for_order, if: proc { order_token.present? }
        before_action :authenticate_user
        before_action :load_user_roles

        rescue_from ActionController::ParameterMissing, with: :error_during_processing
        rescue_from ActiveRecord::RecordInvalid, with: :error_during_processing
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
        rescue_from CanCan::AccessDenied, with: :unauthorized
        rescue_from Spree::Core::GatewayError, with: :gateway_error

        helper Spree::Api::ApiHelpers

        private

        def content_type
          case params[:format]
          when 'json'
            'application/json; charset=utf-8'
          when 'xml'
            'text/xml; charset=utf-8'
          end
        end

        def set_content_type
          headers['Content-Type'] = content_type
        end

        def load_user
          @current_api_user = Spree.user_class.find_by(spree_api_key: api_key.to_s)
        end

        def authenticate_user
          return if @current_api_user

          if requires_authentication? && api_key.blank? && order_token.blank?
            must_specify_api_key and return
          elsif order_token.blank? && (requires_authentication? || api_key.present?)
            invalid_api_key and return
          else
            # An anonymous user
            @current_api_user = Spree.user_class.new
          end
        end

        def invalid_api_key
          render 'spree/api/errors/invalid_api_key', status: 401
        end

        def must_specify_api_key
          render 'spree/api/errors/must_specify_api_key', status: 401
        end

        def load_user_roles
          @current_user_roles = @current_api_user ? @current_api_user.spree_roles.pluck(:name) : []
        end

        def unauthorized
          render 'spree/api/errors/unauthorized', status: 401 and return
        end

        def error_during_processing(exception)
          Rails.logger.error exception.message
          Rails.logger.error exception.backtrace.join("\n")

          unprocessable_entity(exception.message)
        end

        def unprocessable_entity(message)
          render plain: { exception: message }.to_json, status: 422
        end

        def gateway_error(exception)
          @order.errors.add(:base, exception.message)
          invalid_resource!(@order)
        end

        def requires_authentication?
          Spree::Api::Config[:requires_authentication]
        end

        def not_found
          render 'spree/api/errors/not_found', status: 404 and return
        end

        def invalid_resource!(resource)
          @resource = resource
          render 'spree/api/errors/invalid_resource', status: 422
        end

        def api_key
          request.headers['X-Spree-Token'] || params[:token]
        end
        helper_method :api_key

        def order_token
          request.headers['X-Spree-Order-Token'] || params[:order_token]
        end

        def order_id
          params[:order_id] || params[:checkout_id] || params[:order_number]
        end

        def authorize_for_order
          @order = Spree::Order.find_by(number: order_id)
          authorize! :read, @order, order_token
        end
      end
    end
  end
end
