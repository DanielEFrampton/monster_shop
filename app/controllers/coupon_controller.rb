class CouponController < ApplicationController
  def add
    coupon = Coupon.find_by(code: params[:code])
    if coupon
      if coupon.used_by?(current_user)
        flash[:error] = "Ye been at the grog?! Ye can't use the same coupon twice!"
        redirect_to '/orders/new'
      elsif coupon.disabled
        flash[:error] = "Yarr. That coupon was disabled by its merchant. Keelhaul the blaggard!"
        redirect_to '/orders/new'
      else
        session[:coupon_id] = coupon.id
        flash[:success] = "Aye, ye be bilking us good, but yer coupon has been added."
        redirect_to '/orders/new'
      end
    else
      flash[:error] = "There no be such a coupon with such a code. Check yer spellin'."
      redirect_to '/orders/new'
    end
  end

  def remove
    session.delete(:coupon_id)
    redirect_back(fallback_location: '/orders/new')
  end
end
