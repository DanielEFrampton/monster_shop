class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.first
  end

  def update
    item = Item.find(params[:id])
    item.toggle!(:active?)
    if item.active?
      flash[:notice] = "Yer item is active! Now go get the booty.."
    else
      flash[:notice] = "Yer item has scurvy. Inactive!"
    end
    redirect_to '/merchant/items'
  end
end
