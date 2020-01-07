class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if params[:enable_disable] == 'enable'
      @merchant.enable
      flash[:notice] = 'Ahoy! This merchant has re-joined the ranks.'
      redirect_to "/merchants"
    else
      @merchant.disable
      flash[:notice] = 'This merchant has walked the plank.'
      redirect_to "/merchants"
    end
  end
end
