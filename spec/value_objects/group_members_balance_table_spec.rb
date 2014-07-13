require 'spec_helper'

describe GroupMembersBalanceTable do
  let(:value_object) { described_class.new(group) }
  let(:group) { create :group }

  describe '#user_balances_with_colors' do
    let(:result) { value_object.user_balances_with_colors }
    let!(:user_positive) do
      create(:user_group_relationship,
             group: group,
             balance: 10).user
    end
    let!(:user_negative) do
      create(:user_group_relationship,
             group: group,
             balance: -10).user
    end

    it 'returns user balances with amount and color' do
      user_with_negative_color_result = {
        color: '#ff0000',
        y: -10,
      }

      expect(result).to include user_with_negative_color_result
    end
  end
end
