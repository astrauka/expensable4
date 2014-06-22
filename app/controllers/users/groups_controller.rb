module Users
  class GroupsController < ::Users::BaseController
    expose(:group, attributes: :group_params)
    expose(:expenses)

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

    def update
      if group.save
        redirect_to [:user, group],
                    notice: "group saved"
      else
        flash[:alert] = "problem occured"
        render :edit
      end
    end

    def destroy
      if group.destroy
        redirect_to [:user, :groups],
                    notice: "group destroyed"
      else
        redirect_to [:user, :groups],
                    alert: "problem occured"
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
