class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :current_merchant?

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_merchant?
    current_user && current_user.merchant?
  end
end
