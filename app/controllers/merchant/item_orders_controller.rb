class Merchant::ItemOrdersController < Merchant::BaseController
  def update
    item_order = ItemOrder.find(params[:id])
    item_order.toggle!(:fulfilled)
    item_order.item.update!(inventory: item_order.item.inventory - item_order.quantity)
    flash[:success] = "Yarrrgh. I guess I'll split me booty wid ye. Yer order be fulfilled."
    redirect_to "/merchant/orders/#{item_order.order.id}"
  end
end
