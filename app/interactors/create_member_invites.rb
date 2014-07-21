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
      notify_user(fb_id)
    end
  end

  def create_invite(fb_id)
    group.invites.create!(uid: fb_id)
  end

  def notify_user(fb_id)
    if identity = Identity.for_uid(fb_id).first
      UserMailer.group_invite(current_user, group, identity.user).deliver!
    end
  end

  def success?
    !@failed
  end
end
