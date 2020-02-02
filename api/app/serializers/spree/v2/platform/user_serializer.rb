module Spree
  class V2::Platform::UserSerializer
    include FastJsonapi::ObjectSerializer
    attributes :encrypted_password, :password_salt, :email, :remember_token, :persistence_token, :reset_password_token, :perishable_token, :sign_in_count, :failed_attempts, :last_request_at, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :login, :authentication_token, :unlock_token, :locked_at, :reset_password_sent_at, :created_at, :updated_at, :spree_api_key, :remember_created_at, :deleted_at, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
