module Users
  module Groups
    class InvitesController < ::Users::Groups::BaseController
      def index
      end

      def create
        if invited_user_fb_ids
          creator = CreateMemberInvites.new(current_user,
                                            group,
                                            invited_user_fb_ids).run
          # async
          if creator.success?
            flash[:notice] = "invite sent"
            render status: :ok,
                   json: { redirect_to: edit_user_group_url(group) }
          else
            flash[:alert] = "problem occured"
            render status: :ok,
                   json: { redirect_to: edit_user_group_url(group) }
          end
        else
          flash[:alert] = "no friends selected"
          render status: :ok,
                 json: { redirect_to: edit_user_group_url(group) }
        end
      end

      private
      def invited_user_fb_ids
        if (ids = params[:ids]).present?
          if ids.is_a? Array
            ids
          else
            ids.split(',')
          end
        end
      end
    end
  end
end
