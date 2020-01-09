class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Avast! Ye be registered and logged in!"
      redirect_to '/profile'
    elsif @user.duplicate_email?
      flash[:error] = "Scupper that! Yer email already exists in system!"
      render :new
    else
      flash[:error] = "Scupper that! Ye be missing required fields!"
      @user = nil
      redirect_to '/register'
    end
  end

  def show
    @user = current_user
    render file: "/public/404" unless current_user
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:success] = "Your information has been updated."
      render :show
    elsif @user.errors.full_messages == ["Email has already been taken"]
      flash[:error] = "Scupper that! That email do be in use by another scallywag!"
      redirect_to '/profile/edit'
    else
      flash[:error] = "Scupper that! Ye be missing required fields!"
      redirect_to '/profile/edit'
    end
  end

  def edit_password
  end

  def update_password
    user = current_user
    user.update(user_params)
    if user.save
      flash[:success] = "Your password has been updated."
      redirect_to '/profile'
    else
      flash[:error] = "Scupper that! Ye should fill both fields with the same password!"
      redirect_to '/profile/edit_password'
    end
  end

private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
