class GroupMembersBalanceTable
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def categories
    user_group_relationships.by_user_name.map do |rel|
      rel.user.shortened_name
    end
  end

  def data
    user_balances_with_colors.to_json
  end

  def user_balances_with_colors
    user_group_relationships.by_user_name.map do |rel|
      {
        color: color_by_amount(rel.balance.amount),
        y: rel.balance.amount.to_f
      }
    end
  end

  def color_by_amount(amount)
    if amount < 0
      red = 255
      green = 255 - 255 / (negative_min_amount || 1) * amount
    else
      red = 255 - 255 / (positive_max_amount || 1) * amount
      green = 255
    end

    hexadecimal = "##{red.to_i.to_s(16).rjust(2,"0")}#{green.to_i.to_s(16).rjust(2,"0")}00"
  end

  def user_group_relationships
    group.active_user_group_relationships.includes(:user)
  end

  def positive_max_amount
    @positive_max_amount ||=
      user_group_relationships.map do |rel|
        rel.balance.amount
      end.select{ |v| v > 0 }.max
  end

  def negative_min_amount
    @negative_min_amount ||=
      user_group_relationships.map do |rel|
        rel.balance.amount
      end.select{ |v| v < 0 }.min
  end
end
