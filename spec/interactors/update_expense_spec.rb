require 'spec_helper'

describe UpdateExpense do
  let(:interactor) { described_class.new(expense, new_shares) }
  let!(:expense) { create :expense, group: group }
  let!(:user) { group.users.create! attributes_for(:user) }
  let!(:group) { create :group }
  let!(:share) do
    expense.shares.create! attributes_for(:share).merge(user_id: user.id)
  end
  let!(:new_shares) { [new_share] }
  let!(:new_share) { Share.new }

  describe "#substract_old_shares_from_balances" do
    let(:result) { interactor.substract_old_shares_from_balances }

    it "add shares to user balances" do
      result
      # adding to sharers balance
      expect(user.balance_for(group)).to eq share.total_price
    end
  end

  describe "#substract_spending_from_balance" do
    let(:result) { interactor.substract_spending_from_balance }

    it "substracts spending from balance" do
      result
      # removing from payer balance
      expect(expense.payer.balance_for(group)).to eq -expense.spent
    end
  end

  describe "#remove_old_shares_from_expense" do
    let(:result) { interactor.remove_old_shares_from_expense }

    it "removes shares from expense" do
      expect {
        result
      }.to change(expense.shares, :count).by -1
    end
  end
end
