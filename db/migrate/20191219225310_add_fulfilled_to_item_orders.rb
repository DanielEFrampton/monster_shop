class AddFulfilledToItemOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :item_orders, :fulfilled, :boolean, default: false
  end
end
