module Users
  class BaseController < ApplicationController
    before_action :require_current_user!

    # scope to current_user
    expose(:user) { current_user }

    expose(:groups) { user.groups }
    expose(:group)
    expose(:group_users) { group.users }

    private
    def require_current_user!
      if current_user.nil?
        flash[:alert] ||= "Unpermitted action"
        redirect_to root_url
      end
    end
  end
end
