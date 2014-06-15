class CreateUserGroup
  attr_reader :user, :group_params

  def initialize(user, group_params)
    @user = user
    @group_params = group_params
  end

  def run
    group

    self
  end

  def group
    @group ||= user.groups.create(group_params)
  end

  def success?
    group.persisted?
  end
end
