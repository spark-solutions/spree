module Spree
  module V2
    class UserSerializer < BaseSerializer
      set_type :user
      attributes :id, :email
    end
  end
end
