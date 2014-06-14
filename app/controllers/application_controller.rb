class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  # user after sign in path
  def after_sign_in_path_for(resource)
    user_groups_url
  end

  def after_sign_out_path
    root_url
  end
end
