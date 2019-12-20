class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  after_update :change_order_to_packaged

  def subtotal
    price * quantity
  end

  def change_order_to_packaged
    if order.item_orders.where(fulfilled: false).empty?
      order.packaged!
    end
  end
end
