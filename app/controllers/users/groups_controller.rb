module Users
  class GroupsController < ::Users::BaseController
    before_action :require_creator!, only: [:destroy]
    expose(:group, attributes: :group_params)
    expose(:expenses) do |default|
      default.by_created_at_desc.page(params[:page]).per(10)
    end

    def index
    end

    def expenses_table
      render partial: 'expenses_table'
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

    def require_creator!
      unless current_user == group.creator
        redirect_to [:user, :groups],
                    notice: 'unpermitted_action'
      end
    end
  end
end
