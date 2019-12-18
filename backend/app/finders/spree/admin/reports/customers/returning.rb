module Spree
  module Admin
    module Reports
      module Customers
        class Returning < Base
          def call
            returning_users = Spree::Order.complete
            returning_users = by_date_from(returning_users)
            returning_users = by_date_to(returning_users)

            returning_users = returning_users.group(:email).select('email, COUNT(email) as email_qty')

          end
        end
      end
    end
  end
end
