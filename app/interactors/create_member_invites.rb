class CreateMemberInvites
  attr_reader :current_user, :group, :invited_user_fb_ids

  def initialize(current_user, group, invited_user_fb_ids)
    @current_user = current_user
    @group = group
    @invited_user_fb_ids = invited_user_fb_ids
  end

  def run
    begin
      create_invites
    rescue ActiveRecord::RecordInvalid
      @failed = true
    end

    self
  end

  def create_invites
    invited_user_fb_ids.each do |fb_id|
      create_invite(fb_id)
      identity = Identity.for_uid(fb_id).first
      if identity
        notify_user(identity)
        accept_invites(identity)
      end
    end
  end

  def create_invite(fb_id)
    group.invites.create!(uid: fb_id)
  end

  def notify_user(identity)
    UserMailer.group_invite(current_user, group, identity.user).deliver!
  end

  def accept_invites(identity)
    user = identity.user
    user.groups << group if user
  end

  def success?
    !@failed
  end
end
