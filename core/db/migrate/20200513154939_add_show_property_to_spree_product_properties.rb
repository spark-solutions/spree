class AddShowPropertyToSpreeProductProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_product_properties, :show_property, :boolean, default: true unless column_exists?(:spree_product_properties, :show_property)
  end
end
