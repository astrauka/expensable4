module Users
  class BaseController < ApplicationController
    before_action :require_current_user!

    # scope to current_user
    expose(:user) { current_user }

    expose(:groups) { user.groups }
    expose(:group)
    expose(:members) { group.active_users.by_name }
    expose(:members_including_inactive) { group.users.by_name }
    expose(:user_group_relationships) { group.user_group_relationships }
    helper_method :balance_for,
                  :self?

    private

    def balance_for(member)
     user_group_relationships.find do |relationship|
       relationship.user_id == member.id
     end.try(:balance)
    end

    def self?(user)
      current_user == user
    end
  end
end
