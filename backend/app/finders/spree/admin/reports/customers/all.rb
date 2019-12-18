module Spree
  module Admin
    module Reports
      module Customers
        class All < Base
          def initialize(params)
            @params = params
          end

          def call
            users = Spree.user_class.left_outer_joins(:spree_roles)
            users = by_date_range(users)
            users = group(users)

            values = users.map { |day, results| [day, results.size] }
                       .sort_by { |day, _| day }
                       .to_h

            create_report_labels.map do |label|
              [label, values[label] || 0]
            end
          end

          private

          attr_reader :params

          def create_report_labels
            Spree::Admin::Reports::CreateReportLabels.new.call(
              from: date_from.to_date,
              to: date_to.to_date,
              mode: params[:group_by]
            )
          end
        end
      end
    end
  end
end
