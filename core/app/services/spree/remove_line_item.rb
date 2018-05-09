module Spree
  class RemoveLineItem < BaseService
    def call(order:, line_item:, options: nil)
      options ||= {}
      ActiveRecord::Base.transaction do
        line_item.destroy!
        Spree::AfterAddOrRemove.new.call(order: order, line_item: line_item, options: options)
      end
      success(line_item)
    end
  end
end
