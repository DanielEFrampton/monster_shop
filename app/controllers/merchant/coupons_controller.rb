class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Merchant.find(current_user.merchant.id).coupons
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = current_user.merchant.coupons.new(coupon_params)
    if @coupon.save
      redirect_to '/merchant/coupons'
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  private
    def coupon_params
      params.require('coupon').permit(:name, :code, :percent_off)
    end
end
