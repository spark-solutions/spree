class AddStoreToSpreeTaxonomies < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:spree_store, :new_order_notifications_email)
      add_reference :spree_taxonomies, :store, references: :spree_stores, index: true
    end
  end
end
