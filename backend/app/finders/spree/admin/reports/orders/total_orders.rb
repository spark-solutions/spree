module Spree
  module Admin
    module Reports
      module Orders
        class TotalOrders < Base
          def initialize(params)
            @params = params
          end

          def call
            labels = create_report_labels

            orders = Spree::Order.complete
            orders = by_date_from(orders)
            orders = by_date_to(orders)
            orders = grouped_by(orders)
            values = orders.map { |day, results| [day, results.count] }.sort_by { |day, _| day }.to_h

            labels.map { |label| [label, values[label] || 0] }
          end
        end
      end
    end
  end
end
