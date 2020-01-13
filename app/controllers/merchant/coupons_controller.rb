class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Merchant.find(current_user.merchant.id).coupons
  end

  def new
    @coupon = Coupon.new
  end

  def create
  end
end
