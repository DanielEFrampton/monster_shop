class Cart
  attr_reader :contents, :coupon

  def initialize(contents, coupon_id=nil)
    @contents = contents
    @coupon = Coupon.find(coupon_id) if coupon_id
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def discounted_price(item)
    item.discounted_price(@coupon.percent_off)
  end

  def discounted_subtotal(item)
    discounted_price(item) * @contents[item.id.to_s]
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def discounted_total
    @contents.sum do |item_id, quantity|
      item = Item.find(item_id)
      if item.merchant_id == @coupon.merchant_id
        item.discounted_price(@coupon.percent_off) * quantity
      else
        item.price * quantity
      end
    end
  end

  def add_quantity(item_id)
    @contents[item_id] += 1
  end

  def subtract_quantity(item_id)
    @contents[item_id] -= 1
  end

  def limit_reached?(item_id)
    @contents[item_id.to_s] == Item.find(item_id).inventory
  end

  def quantity_zero?(item_id)
    @contents[item_id] == 0
  end
end
