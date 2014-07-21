class ExpenseForm
  attr_reader :user, :group, :params

  def initialize(user, group, params)
    @user = user
    @group = group
    @params = params.with_indifferent_access
  end

  def save
    UpdateExpense.new(expense, shares_to_be_persisted).run.success?
  end

  def expense
    @expense ||=
      begin
        e = group.expenses.find_or_initialize_by(id: params[:expense_id])
        e.creator = user
        e.payer ||= user
        e.spent = expense_attributes.delete(:spent)
        e.assign_attributes expense_attributes

        e
      end
  end

  def expense_attributes
    params.fetch(:expense_attributes, {})
  end

  def old_shares
    @old_shares ||= expense.shares
  end

  def new_shares
    @new_shares =
      available_for_expense_user_ids.map do |user_id|
        Share.new(
          user_id: user_id,
          multiplier: old_share_multiplier_for(user_id) || 0
        )
      end
  end

  def available_for_expense_users
    # include deactivated user if he is sharing
    (expense.sharing_users + group.active_users + [expense.payer]).compact.uniq
  end

  def available_for_expense_user_ids
    available_for_expense_users.map(&:id)
  end

  def old_share_multiplier_for(user_id)
    old_shares.find do |share|
      share.user_id == user_id
    end.try(:multiplier)
  end

  def shares_to_be_persisted
    shares_with_sharing_input.select do |share_with_sharing_input|
      share_with_sharing_input.sharing == '1'
    end.map(&:share)
  end

  def shares_with_sharing_input_attributes=(attributes)
    # for simple_fields_for
  end

  def expense_attributes=(attributes)
    # for simple_fields_for
  end

  def single_share_price_input
    # for form, will display calculated share price
  end

  def shares_with_sharing_input
    new_shares.map do |share|
      share.multiplier = multiplier_for(share)
      ShareWithSharingInput.new(share, sharing_for(share))
    end
  end

  def shares_params
    @shares_params ||= params[:shares_with_sharing_input_attributes]
  end

  def share_params_for(share)
    if shares_params
      shares_params.values.find do |param|
        param[:user_id] == share.user_id.to_s
      end
    end
  end

  def sharing_for(share)
    if share_params_for(share)
      share_params_for(share)[:sharing]
    else
      old_shares.map(&:user_id).include? share.user_id
    end
  end

  def multiplier_for(share)
    if share_params_for(share)
      share_params_for(share)[:multiplier]
    else
      share.multiplier
    end
  end

  def payback_user
    if user_id = params[:payback_user_id]
      group.active_users.find(user_id)
    end
  end
end
