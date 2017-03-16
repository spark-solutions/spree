class AddUniqueIndexOnNumberToSpreeOrders < ActiveRecord::Migration[5.0]
  def up
    numbers = Spree::Order.group(:number).having('sum(1) > 1').pluck(:number)
    orders = Spree::Order.where(number: numbers)

    orders.find_each do |order|
      order.number = order.class.number_generator.method(:generate_permalink).call(order.class)
      order.save
    end

    add_index :spree_orders, :number, unique: true
  end

  def down
    remove_index :spree_orders, :number
  end
end
