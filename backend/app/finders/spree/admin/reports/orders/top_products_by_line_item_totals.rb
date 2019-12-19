module Spree
  module Admin
    module Reports
      module Orders
        class TopProductsByLineItemTotals < Base
          def initialize(params)
            @params = params
            @top = params[:top]
          end

          def call
            variants = Spree::Variant.joins(:prices, line_items: :order)
            variants = by_date_from(variants)
            variants = by_date_to(variants)

            variants = variants.group(
                                 "#{Spree::Variant.table_name}.id",
                                 "#{Spree::Variant.table_name}.is_master",
                                 "#{Spree::Variant.table_name}.product_id"
                               )
                               .select(
                                 "#{Spree::Variant.table_name}.id",
                                 "#{Spree::Variant.table_name}.is_master",
                                 "#{Spree::Variant.table_name}.product_id",
                                 "sum(#{Spree::LineItem.table_name}.quantity * #{Spree::LineItem.table_name}.price + #{Spree::LineItem.table_name}.adjustment_total) as line_item_total"
                               )
                               .order(line_item_total: :desc)

            variants = by_top(variants)

            variants.to_a.map { |v| [v.descriptive_name, v.line_item_total] }
          end

          private

          attr_reader :top

          def by_top(variants)
            return variants if top.nil?

            variants.limit(top)
          end

          def by_date_from(variants)
            return variants unless date_from

            variants.where('spree_orders.completed_at >= ?', date_from.beginning_of_day)
          end

          def by_date_to(variants)
            return variants unless date_to

            variants.where('spree_orders.completed_at <= ?', date_to.end_of_day)
          end
        end
      end
    end
  end
end
