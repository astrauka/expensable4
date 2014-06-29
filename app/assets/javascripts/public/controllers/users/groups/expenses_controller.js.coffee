class Public.Users_Groups_ExpensesController
  new_action: =>
    @manage_expense_form()

  create_action: =>
    @manage_expense_form()

  edit_action: =>
    @manage_expense_form()

  update_action: =>
    @manage_expense_form()

  manage_expense_form: =>
    new app.ExpenseForm('.expense-form').bind()
