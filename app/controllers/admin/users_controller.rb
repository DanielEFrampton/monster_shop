class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      flash[:success] = "Your information has been updated."
      render :show
    elsif @user.errors.full_messages == ["Email has already been taken"]
      flash[:error] = "Scupper that! That email do be in use by another scallywag!"
      redirect_to "/admin/users/#{@user.id}/edit"
    else
      flash[:error] = "Scupper that! Ye be missing required fields!"
      redirect_to "/admin/users/#{@user.id}/edit"
    end
  end

  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    @user.update(update_pass_params)
    if @user.save
      flash[:success] = "The password has been updated."
      redirect_to "/admin/users/#{@user.id}"
    else
      flash[:error] = "Scupper that! Ye should fill both fields with the same password!"
      redirect_to "/admin/users/#{@user.id}/edit_password"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :address, :city, :state, :zip, :email)
    end

    def update_pass_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
