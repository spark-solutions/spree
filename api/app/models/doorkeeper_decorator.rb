Doorkeeper::AccessToken.class_eval do
  self.table_name = 'spree_oauth_access_tokens'
end

Doorkeeper::AccessGrant.class_eval do
  self.table_name = 'spree_oauth_access_grants'
end

Doorkeeper::Application.class_eval do
  self.table_name = 'spree_oauth_applications'
end
