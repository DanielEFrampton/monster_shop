class Admin::OrdersController < Admin::BaseController

  def index
    @user = User.find(params[:user_id])
  end

  def show
    @order = Order.find(params[:id])
  end
end
