class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_numericality_of :price, greater_than: 0

  def self.most_popular(num)
    joins(:item_orders)
    .group(:id)
    .order('SUM(item_orders.quantity) DESC')
    .limit(num)
  end

  def self.least_popular(num)
    joins(:item_orders)
    .group(:id)
    .order('SUM(item_orders.quantity)')
    .limit(num)
  end

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def quantity_ordered
    item_orders.sum(:quantity)
  end

  def discounted_price(percent_off)
    if percent_off > 0
      price - (price * (percent_off / 100.0))
    else
      price
    end
  end
end
