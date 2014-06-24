module Users
  module Groups
    class ExpensesController < ::Users::Groups::BaseController
      expose(:expense_form) { ExpenseForm.new(user, group, expense_params) }
      expose(:expense) { expense_form.expense }

      def new
        self.expense_form = ExpenseForm.new user, group, {}
      end

      def create
        if expense_form.save
          redirect_to [:user, group],
                      notice: "created successfully"
        else
          flash[:notice] = 'problem occured'
          render :new
        end
      end

      private

      def expense_params
        params.require(:expense_form).permit(
          expense: [
            :payer_id,
            :spent,
            :description,
            :hidden,
          ],
          shares_with_sharing_input_attributes: [
            :multiplier,
            :sharing,
            :user_id,
          ]
        )
      end
    end
  end
end
