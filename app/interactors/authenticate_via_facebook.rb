class AuthenticateViaFacebook
  attr_reader :auth, :user

  def initialize(auth)
    @auth = Hashie::Mash.new auth
  end

  def run
    begin
      create_or_update_user
      accept_invites
    rescue ActiveRecord::RecordInvalid
      @failed = true
    end

    self
  end

  def identity
    @identity ||= Identity.for_oauth(auth)
  end

  def create_or_update_user
    @user = identity.user || identity.build_user
    user.update!(
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name
    )

    # persist user_id
    identity.save!

    user
  end

  def accept_invites
    if newly_invited_group_ids.any?
      user.groups << Group.where(id: newly_invited_group_ids)
    end
  end

  def newly_invited_group_ids
    @newly_invited_group_ids ||= not_accepted_group_ids - user.group_ids
  end

  def not_accepted_group_ids
    Invite.for_uid(identity.uid)
          .not_accepted
          .map(&:group_id)
  end

  def success?
    !@failed
  end
end
