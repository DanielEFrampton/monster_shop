class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def enable
    merchant = Merchant.find(params[:id])
    merchant.update(disabled: false)
    merchant.items.update_all(disabled: false)
    flash[:notice] = 'Ahoy! This merchant has re-joined the ranks.'
    redirect_to "/merchants"
  end

  def disable
    merchant = Merchant.find(params[:id])
    merchant.update(disabled: true)
    merchant.items.update_all(disabled: true)
    flash[:notice] = 'This merchant has walked the plank.'
    redirect_to "/merchants"
  end
end
