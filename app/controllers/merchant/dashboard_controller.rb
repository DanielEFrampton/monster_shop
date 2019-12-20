class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = User.find(current_user.id)
  end
end
