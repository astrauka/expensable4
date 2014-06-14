class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # user after sign in path
  def new_session_path(scope)
    case scope.to_sym
    when :user
      user_groups_url(current_user)
    else
      root_url
    end
  end

  def after_sign_out_path
    root_url
  end
end
