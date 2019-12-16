class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)

    if user.save
      session[:user_id] = user.id
      flash[:notice] = "Avast! Ye be registered and logged in!"
      redirect_to '/profile'
    else
      flash[:notice] = "Scupper That! Ye did not complete all fields!"
      render "new"
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
