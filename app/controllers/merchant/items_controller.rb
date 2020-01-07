class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.first
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      flash[:success] = "Yer booty has been corrected!"
      redirect_to '/merchant/items'
    else
      flash[:error] = item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/#{item.id}/edit"
    end
  end

  def activate
    item = Item.find(params[:id])
    item.toggle!(:active?)
    if item.active?
      flash[:notice] = "Yer item is active! Now go get the booty.."
    else
      flash[:notice] = "Yer item has scurvy. Inactive!"
    end
    redirect_to '/merchant/items'
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
