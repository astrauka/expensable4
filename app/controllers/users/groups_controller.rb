module Users
  class GroupsController < ::Users::BaseController
    expose(:groups) { user.groups }
    expose(:group, attributes: :group_params)

    def index
    end

    def new
    end

    def create
      creator = CreateUserGroup.new(user, group_params).run
      self.group = creator.group
      if creator.success?
        redirect_to [:user, group],
                    notice: "group saved"
      else
        flash[:alert] = "problem occured"
        render :new
      end
    end

    private
    def group_params
      params.require(:group).permit(
        :name
      )
    end
  end
end
