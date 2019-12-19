class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end
end
