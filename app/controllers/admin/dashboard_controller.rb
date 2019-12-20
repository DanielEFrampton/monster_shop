class Admin::DashboardController < Admin::BaseController

  def index
    @orders = Order.order(:status)
  end
end
