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
    render file: "/public/404" unless current_user
  end

  def edit
  end

  def update
    user = current_user
    user.update(user_params)
    if user.save
      flash[:notice] = "Your information has been updated."
      render :show
    else
      flash[:notice] = "Scupper that! Ye be missing required fields!"
      redirect_to '/profile/edit'
    end
  end

  def update_password
    user = current_user
    user.update(user_params)
    if user.save
      flash[:notice] = "Your password has been updated."
      redirect_to '/profile'
    else
      flash[:notice] = "Scupper that! Ye should fill both fields with the same password!"
      redirect_to '/profile/edit_password'
    end
  end

  def edit_password
  end

private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
