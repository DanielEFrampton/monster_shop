class Merchant::DashboardController < Merchant::BaseController

  def index
    if current_user.merchant_id != nil
      @merchant = Merchant.find(current_user.merchant_id)
    end
  end
end
