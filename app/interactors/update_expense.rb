class UpdateExpense
  attr_reader :expense, :new_shares

  def initialize(expense, new_shares)
    @expense = expense
    @new_shares = new_shares
  end

  delegate :group, to: :expense

  def run
    begin
      Expense.transaction do
        if expense.persisted?
          substract_old_shares_from_balances
          substract_spending_from_balance
          remove_old_shares_from_expense
        end

        expense.save!

        add_new_shares_to_expense
        add_bew_shares_to_balances
        add_spending_to_balance
      end
    rescue ActiveRecord::RecordInvalid
      @failed = true
    end

    self
  end

  def relationship_for(user, group)
    UserGroupRelationship.find_or_initialize_by(
      user_id: user.id,
      group_id: group.id
    )
  end


  def substract_old_shares_from_balances
    expense.shares.each do |share|
      relationship = relationship_for share.user, group
      relationship.balance += share.total_price
      relationship.save!
    end
  end

  def substract_spending_from_balance
    relationship = relationship_for expense.payer, group
    relationship.balance -= expense.spent
    relationship.save!
  end

  def remove_old_shares_from_expense
    expense.shares.each(&:destroy)
  end

  def add_new_shares_to_expense

  end

  def add_new_shares_to_balances

  end

  def add_spending_to_balance

  end

  def success?
    !@failed
  end
end
