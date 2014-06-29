class UsersController < ApplicationController
  before_action :require_current_user!
  expose(:user) { current_user }

  # can only edit self

  def edit
  end

  def update
    if user.update(user_params)
      redirect_to [:edit, :user],
                  notice: 'updated successfully'
    else
      flash[:alert] = 'problem occured'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :id,
      :account_number,
    )
  end
end
