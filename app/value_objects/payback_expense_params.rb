class PaybackExpenseParams
  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
  end

  def result
    @result ||= { expense_form: form_params }
  end

  def form_params
    {
      expense_attributes: {
        description: "payback to #{max_balance.user}",
        spent: [max_balance.balance, group.balance_for(user).abs].min,
        payer_id: user.id,
      },
      shares_with_sharing_input_attributes: shares_params,
      payback_user_id: max_balance.user_id,
    }
  end

  def shares_params
    expense_form.available_for_expense_user_ids
                .each
                .with_index
                .reduce({}) do |memo, (user_id, index)|
      memo[index] =
        if user_id == max_balance.user_id
          {
            user_id: user_id,
            multiplier: '1',
            sharing: '1',
          }
        else
          {
            user_id: user_id,
          }
        end

      memo
    end
  end

  def expense_form
    @expense_form ||= ExpenseForm.new(user, group, {})
  end

  def max_balance
    @max_balance ||= group.active_user_group_relationships.by_balance.last
  end
end
