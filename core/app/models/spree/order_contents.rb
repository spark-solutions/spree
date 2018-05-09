module Spree
  class OrderContents
    attr_accessor :order, :currency

    def initialize(order)
      @order = order
    end

    def add(variant, quantity = 1, options = {})
      puts 'DEPRECATED ADDING STUFF IN ORDER CONTENTS'
      Spree::AddItemToCart.new.call(order: order, variant: variant, quantity: quantity, options: options).value
    end

    def remove(variant, quantity = 1, options = {})
      puts 'DEPRECATED REMOVING STUFF IN ORDER CONTENTS'
      Spree::RemoveItemFromCart.new.call(order: order, variant: variant, quantity: quantity, options: options).value
    end

    def remove_line_item(line_item, options = {})
      puts 'DEPRECATED REMOVING LINE ITEM IN ORDER CONTENTS'
      Spree::RemoveLineItem.new.call(order: @order, line_item: line_item, options: options).value
    end

    def update_cart(params)
      puts 'DEPRECATED UPDATE CART IN ORDERS CONTENTS'
      Spree::UpdateCart.new.call(order: order, params: params).value
    end
  end
end
