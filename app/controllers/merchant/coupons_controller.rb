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

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    @coupon.update(coupon_params)
    if @coupon.save
      redirect_to '/merchant/coupons'
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    coupon = Coupon.find(params[:id])
    if coupon.used?
      flash[:error] = "Scupper that! This here coupon been used on an order, ye can't delete it."
    else
      coupon.delete
      flash[:success] = "Ye sent that blasted coupon into the briny deep! Aye, 'twas deleted."
    end
    redirect_to '/merchant/coupons'
  end

  private
    def coupon_params
      params.require('coupon').permit(:name, :code, :percent_off)
    end
end
