class SessionsController < ApplicationController
  def new
    if !session[:user_id].nil?
      flash[:already_registered] = "Arr. Ye be already logged in."
      redirect(current_user)
    end
  end

  def create
    unless login_attempt(params)
      flash[:bad_credentials] = 'Avast! Thar be problems with the credentials ye input!'
      redirect_to '/login'
    end
  end

private

  def login_attempt(params)
    user = User.find_by(email: params[:email])
    if !user.nil? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect(user)
    end
  end

  def redirect(user)
    if user.default?
      redirect_to '/profile'
    else
      redirect_to "/#{user.role}"
    end
  end
end
