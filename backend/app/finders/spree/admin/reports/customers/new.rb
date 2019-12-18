module Spree
  module Admin
    module Reports
      module Customers
        class New < Customers::Base
          def initialize(params)
            @params = params
          end

          def call
            new_customers = Spree::Order.complete
            new_customers = by_date_from(returning_users)
            new_customers = by_date_to(returning_users)

            new_customers = new_customers.group(:email).select('email, COUNT(email) as email_qty')

          end
        end
      end
    end
  end
end
