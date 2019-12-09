module Spree
  module Admin
    module Reports
      module TotalSales
        class JsonSerializer
          def call(objects)
            serialized_objects = { labels: [], data: [] }

            objects.each do |day, total_sales|
              serialized_objects[:labels].push(day)
              serialized_objects[:data].push(total_sales)
            end

            serialized_objects
          end
        end
      end
    end
  end
end