class OrdersController <ApplicationController
  before_action :format_params

  def new
  end

  def index
    @user = current_user
    @orders = @user.orders
  end

  def show
  end

  def create
    user = User.find(params[:id])
    order = user.orders.new(order_params)
    if order.save
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
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    order.update(update_params)
    unless order.save
      flash[:error] = order.errors.full_messages.to_sentence
    end
    redirect_to '/admin'
  end

  private

  def format_params
    params[:status] = params[:status].to_i
  end

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def update_params
    params.permit(:status)
  end
end
