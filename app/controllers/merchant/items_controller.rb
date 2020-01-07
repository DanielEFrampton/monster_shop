class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.first
  end

  def update
    item = Item.find(params[:id])
    item.toggle!(:active?)
    redirect_to '/merchant/items'
  end
end
