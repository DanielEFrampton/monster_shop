class OrdersController <ApplicationController

  def index
    @user = current_user
    @orders = @user.orders
  end

  def show
  end

  def create
    user = User.find(params[:id])
    order = user.orders.create(order_params)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
    end
    session.delete(:cart)
    flash[:order_created] = 'Order ho! Ye successfully placed yer order. Make way in yer hold for loot!'
    redirect_to "/profile/orders"
  end


  private

  def order_params
    {name: current_user.name,
    address: current_user.address,
    state: current_user.state,
    city: current_user.city,
    zip: current_user.zip}
  end
end
