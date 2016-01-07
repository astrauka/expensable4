class UserController < ApplicationController
  def index
    @user_props = { name: "Stranger" }
  end
end
