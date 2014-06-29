class UserDecorator < ApplicationDecorator
  def toggle_active_text(group)
    if user_group_relationship_for(group).active
      'deactivate'
    else
      'activate'
    end
  end

  def active_yes_no(group)
    if user_group_relationship_for(group).active
      'yes'
    else
      'no'
    end
  end
end
