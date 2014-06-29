module Users
  module Groups
    class MembersController < ::Users::Groups::BaseController
      expose(:member) { group.users.find(params[:id]) }

      def toggle_active
        if toggle_active_member.run.success?
          notice = if toggle_active_member.activated?
                     'member activated'
                   else
                     'member deactivated'
                   end

          redirect_to [:edit, :user, group],
                      notice: notice
        else
          redirect_to [:edit, :user, group],
                      alert: 'problem occured'
        end
      end

      private

      def toggle_active_member
        @toggle_active_member ||=
          ToggleActiveMember.new(group, member)
      end
    end
  end
end
