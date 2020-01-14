class ItemsController<ApplicationController
  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items.where(disabled: false)
    else
      @items = Item.all.where(disabled: false)
    end
  end

  def show
    @item = Item.find(params[:id])
  end
end
