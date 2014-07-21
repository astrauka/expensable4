class UpdateExpense
  def self.destroy(expense)
    new(expense, [], true).run
  end

  attr_reader :expense, :new_shares, :destroy

  def initialize(expense, new_shares, destroy = false)
    @expense = expense
    @new_shares = new_shares
    @destroy = destroy
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

        if destroy
          expense.destroy!
        else
          cache_participating_user_ids
          expense.save!

          add_new_shares_to_expense
          add_new_shares_to_balances
          add_spending_to_balance
        end
      end
    rescue ActiveRecord::RecordInvalid, ZeroDivisionError
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

  def update_balance_for(user, group)
    relationship = relationship_for user, group
    relationship.balance = yield relationship.balance
    relationship.save!
  end

  def substract_old_shares_from_balances
    expense.shares.each do |share|
      update_balance_for(share.user, group) do |balance|
        balance + share.total_price
      end
    end
  end

  def substract_spending_from_balance
    update_balance_for(old_payer, group) do |balance|
      balance - old_paid
    end
  end

  def old_payer
    group.users.find(expense.payer_id_was)
  end

  def old_paid
    Money.new(expense.spent_cents_was)
  end

  def remove_old_shares_from_expense
    expense.shares.destroy_all
  end

  def new_single_share_price_cents
    @new_single_share_price_cents ||=
      expense.spent_cents / new_shares.sum(&:multiplier)
  end

  def add_new_shares_to_expense
    new_shares.map do |share|
      expense.shares.create!(
        share.attributes.merge(single_price_cents: new_single_share_price_cents)
      )
    end
  end

  def add_new_shares_to_balances
    expense.shares.each do |share|
      update_balance_for(share.user, group) do |balance|
        balance - share.total_price
      end
    end
  end

  def add_spending_to_balance
    update_balance_for(expense.payer, group) do |balance|
      balance + expense.spent
    end
  end

  def success?
    !@failed
  end

  def cache_participating_user_ids
    expense.participating_user_ids =
      (expense.shares.map(&:user_id) << expense.payer_id).uniq.compact
  end
end
