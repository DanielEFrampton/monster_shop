class MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to merchants_path
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end

end
