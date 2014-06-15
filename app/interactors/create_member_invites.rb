class CreateMemberInvites
  attr_reader :group, :invited_user_fb_ids

  def initialize(group, invited_user_fb_ids)
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
    end
  end

  def create_invite(fb_id)
    group.invites.create!(uid: fb_id)
  end

  def success?
    !@failed
  end
end
