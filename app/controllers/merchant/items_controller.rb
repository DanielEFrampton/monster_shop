class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
    @item = current_user.merchant.items.new
  end

  def create
    item = current_user.merchant.items.new(item_params)
    if item.save
      flash[:success] = "Yer hold be brimming with booty! Er, yer item do be created."
      redirect_to '/merchant/items'
    else
      flash[:error] = 'No'
      redirect_to '/merchant/items/new'
    end
  end

  def update
    item = Item.find(params[:id])
    item.toggle(:active?).save
    if item.active?
      flash[:notice] = "Yer item is active! Now go get the booty.."
    else
      flash[:notice] = "Yer item has scurvy. Inactive!"
    end
    redirect_to '/merchant/items'
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :image, :price, :inventory)
  end
end
