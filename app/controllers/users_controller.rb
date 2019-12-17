class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Avast! Ye be registered and logged in!"
      redirect_to '/profile'
    elsif @user.duplicate_email?
      flash[:notice] = "Scupper that! Yer email already exists in system!"
      render :new
    else
      flash[:notice] = "Scupper that! Ye be missing required fields!"
      @user = nil
      redirect_to '/register'
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
