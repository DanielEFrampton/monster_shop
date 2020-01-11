class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :coupons

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders
    Order.joins(:items).distinct.where(items: {merchant_id: id}).where(status: 'pending')
  end

  def enable
    update(disabled: false)
    items.update_all(disabled: false)
  end

  def disable
    update(disabled: true)
    items.update_all(disabled: true)
  end
end
