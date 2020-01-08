class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
    @item = Merchant.find(current_user.merchant_id).items.new
  end

  def create
    @item = Merchant.find(current_user.merchant_id).items.new(item_params)
    if @item.save
      flash[:success] = "Yer hold be brimming with booty! Er, yer item do be created."
      redirect_to '/merchant/items'
    else
      flash[:error] = "Avast! There do be fields missing or incorrect. #{@item.errors.full_messages.to_sentence}. Ye scallywag."
      render :new
    end
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
    item.toggle(:active?).save
    if item.active?
      flash[:success] = "Yer item is active! Now go get the booty.."
    else
      flash[:success] = "Yer item has scurvy. Inactive!"
    end
    redirect_to '/merchant/items'
  end

  def destroy
    item = Item.find(params[:id])
    if item.orders.empty?
      item.destroy
      flash[:success] = "Yer item walked the plank fer good!"
    else
      flash[:error] = "ARGH! Ye shan't be deletin booty that's already been plundered!"
    end
    redirect_to '/merchant/items'
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :image, :price, :inventory)
  end
end
