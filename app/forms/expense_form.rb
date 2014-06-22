class ExpenseForm
  attr_reader :user, :group, :params

  def initialize(user, group, params)
    @user = user
    @group = group
    @params = params
  end

  def save
    begin
      Expense.transaction do
        remove_old_shares_from_balances
        update_expense
        add_new_shares_to_balances
      end
    rescue ActiveRecord::RecordInvalid
      @failed = true
    end
  end

  def expense
    @expense ||= group.build(:expense).tap do |e|
      e.creator = user
    end
  end

  def shares_attributes
    # for simple_fields_for
  end

  def remove_old_shares_from_balances

  end

  def update_expense

  end

  def add_new_shares_to_balances

  end

  def success?
    !@failed
  end
end
