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
        e.assign_attributes params.fetch(:expense, {})

        e
      end
  end

  def old_shares
    @old_shares ||= expense.shares
  end

  def new_shares
    @new_shares ||= (old_shares + missing_shares)
  end

  def missing_shares
    (group.active_user_ids - expense.sharing_user_ids).map do |user_id|
      Share.new(
        user_id: user_id,
        multiplier: 0
      )
    end
  end

  def shares_to_be_persisted
    shares_with_sharing_input.select do |share_with_sharing_input|
      share_with_sharing_input.sharing
    end.map(&:share)
  end

  def shares_with_sharing_input_attributes=(attributes)
    # for simple_fields_for
  end

  def shares_with_sharing_input
    new_shares.map do |share|
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
    end
  end
end
