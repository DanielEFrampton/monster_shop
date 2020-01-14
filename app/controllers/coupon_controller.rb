class CouponController < ApplicationController
  def add
    coupon = Coupon.find_by(code: params[:code])
    if coupon
      session[:coupon_id] = coupon.id
      flash[:success] = "Aye, ye be bilking us good, but yer coupon has been added."
      redirect_to '/orders/new'
    else
      flash[:error] = "There no be such a coupon with such a code. Check yer spellin'."
      redirect_to '/orders/new'
    end
  end
end
