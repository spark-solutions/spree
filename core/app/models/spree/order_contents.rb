module Spree
  class OrderContents
    attr_accessor :order, :currency

    def initialize(order)
      @order = order
    end

    def add(variant, quantity = 1, options = {})
      puts 'DEPRECATED ADDING STUFF IN ORDER CONTENTS'
      Spree::Cart::AddItem.call(order: order, variant: variant, quantity: quantity, options: options).value
    end

    def remove(variant, quantity = 1, options = {})
      puts 'DEPRECATED REMOVING STUFF IN ORDER CONTENTS'
      Spree::Cart::RemoveItem.call(order: order, variant: variant, quantity: quantity, options: options).value
    end

    def remove_line_item(line_item, options = {})
      puts 'This action is deprecated since it was never used in spree, so it will be removed in spree 4.0'
      Spree::Cart::RemoveLineItem.call(order: @order, line_item: line_item, options: options).value
    end

    def update_cart(params)
      puts 'DEPRECATED UPDATE CART IN ORDERS CONTENTS'
      Spree::Cart::Update.call(order: order, params: params).value
    end
  end
end
