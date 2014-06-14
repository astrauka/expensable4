class SessionsController < Devise::SessionsController
  # do not allow sign in via email
  before_action :redirect_to_root!, except: :destroy

  private
  def redirect_to_root!
    redirect_to root_url
  end
end
