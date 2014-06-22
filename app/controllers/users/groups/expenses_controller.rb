module Users
  module Groups
    class ExpensesController < ::Users::Groups::BaseController
      expose(:expense_form) { ExpenseForm.new(user, group, expense_params) }
      expose(:expense) { expense_form.expense }

      def new
        self.expense = Expense.new payer: user
      end

      def create
        creator = CreateMemberInvites.new(group, invited_user_fb_ids).run
        # async
        if creator.success?
          flash[:notice] = "invite sent"
          render status: :ok,
                 json: { redirect_to: edit_user_group_url(group) }
        else
          flash[:alert] = "problem occured"
          render status: :unprocessable_entity,
                 json: { redirect_to: edit_user_group_url(group) }
        end
      end

      private

      def expense_params
        params.require(:expense).permit(
          :payer,
          :spent,
          :description,
          :hidden,
          shares_attributes: [
            :multiplier,
            :sharing,
          ]
        )
      end
    end
  end
end
