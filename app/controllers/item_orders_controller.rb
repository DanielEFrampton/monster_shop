class ItemOrdersController < ApplicationController
  def update
    item_order = ItemOrder.find(params[:id])
    item_order.toggle(:fulfilled).save
    item = item_order.item
    item.update(inventory: new_quantity(item, item_order))
    item.save
    flash[:fulfilled] = "Yarrrgh. I guess I'll split me booty wid ye. Yer order be fulfilled."
    redirect_to "/merchant/orders/#{item_order.order.id}"
  end

  private

  def new_quantity(item, item_order)
    item.inventory - item_order.quantity
  end
end
