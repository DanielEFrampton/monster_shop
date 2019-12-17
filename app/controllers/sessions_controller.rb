class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.default?
        redirect_to '/profile'
      elsif user.merchant?
        redirect_to '/merchant'
      elsif user.admin?
        redirect_to '/admin'
      end
    end
  end
end
