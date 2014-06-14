module Users
  class GroupsController < ::Users::BaseController
    expose(:groups) { user.groups }

    def index
    end
  end
end
