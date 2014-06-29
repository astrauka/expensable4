class ToggleActiveMember
  attr_reader :group, :member

  def initialize(group, member)
    @group = group
    @member = member
  end

  def run
    @success = toggle_active

    self
  end

  def toggle_active
    user_group_relationship.update_attribute :active, new_state
  end

  def new_state
    @new_state ||= !user_group_relationship.active
  end

  def user_group_relationship
    @user_group_relationship ||=
      member.user_group_relationship_for(group)
  end

  def activated?
    user_group_relationship.active
  end

  def success?
    @success
  end
end

