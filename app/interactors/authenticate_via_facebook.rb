class AuthenticateViaFacebook
  attr_reader :auth, :user

  def initialize(auth)
    @auth = Hashie::Mash.new auth
  end

  def run
    @user = create_or_update_user
    @success = user.persisted? && identity.persisted?

    self
  end

  def identity
    @identity ||= Identity.for_oauth(auth)
  end

  def create_or_update_user
    user = identity.user || identity.build_user
    user.update(
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name
    )

    # persist user_id
    identity.save

    user
  end

  def success?
    @success
  end
end
