class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authenticator = AuthenticateViaFacebook.new(env["omniauth.auth"]).run
    if authenticator.success?
      sign_in_and_redirect authenticator.user, event: :authentication
      flash[:notice] = "Signed in successfully." if is_navigational_format?
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
