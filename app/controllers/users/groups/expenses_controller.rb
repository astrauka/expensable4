module Users
  module Groups
    class ExpensesController < ::Users::Groups::BaseController
      expose(:expense_form) { ExpenseForm.new(user, group, expense_params) }
      expose(:expense) { expense_form.expense }

      def new
      end

      def create
        if expense_form.save
          redirect_to [:user, group],
                      notice: 'created successfully'
        else
          flash[:notice] = 'problem occured'
          render :new
        end
      end

      def edit
      end

      def update
        if expense_form.save
          redirect_to [:user, group],
                      notice: 'updated successfully'
        else
          flash[:notice] = 'problem occured'
          render :edit
        end
      end

      def destroy
        self.expense = Expense.find(params[:id])

        if UpdateExpense.destroy(expense).success?
          redirect_to [:user, group],
                      notice: 'deleted successfully'
        else
          redirect_to [:user, group],
                      alert: 'problem occured'
        end
      end

      private

      def expense_params
        params[:expense_form] ||= {}
        params[:expense_form][:expense_id] = params[:id]

        params.require(:expense_form).permit(
          :expense_id,
          expense_attributes: [
            :id,
            :payer_id,
            :spent,
            :description,
            :hidden,
          ],
          shares_with_sharing_input_attributes: [
            :id,
            :multiplier,
            :sharing,
            :user_id,
          ]
        )
      end
    end
  end
end
