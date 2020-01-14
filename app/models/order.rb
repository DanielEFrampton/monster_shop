class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user
  belongs_to :coupon, optional: true

  enum status: %w(pending packaged shipped cancelled)

  after_update :change_order_to_unfulfilled

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum('quantity')
  end

  def change_order_to_unfulfilled
    if self.cancelled?
      item_orders.each do |item_order|
        item_order.update!(fulfilled: false)
      end
    end
  end

  def item_count_for_merchant(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum(:quantity)
  end

  def grand_total_for_merchant(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum('item_orders.quantity * item_orders.price')
  end
end
