class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in

  def current_user
    if session[:user_id]
      User.find_by_id(session[:user_id])
    end
  end

  def signed_in
    current_user.present?
  end

  def require_login
    unless signed_in
      flash[:error] = "You must sign in to see this page"
      redirect_to login_path
    end
  end
end
