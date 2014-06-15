class CreateUserGroup
  attr_reader :user, :group_params

  def initialize(user, group_params)
    @user = user
    @group_params = group_params
  end

  def run
    begin
      persist_group
    rescue ActiveRecord::RecordInvalid
      @failed = true
    end

    self
  end

  def persist_group
    group.save!
    add_user_to_the_group
  end

  def group
    @group ||= user.groups.build(group_params)
  end

  def add_user_to_the_group
    group.users << user
  end

  def success?
    !@failed
  end
end
