require 'spec_helper'

describe UpdateExpense do
  let(:interactor) { described_class.new(expense, new_shares) }
  let!(:expense) { create :expense, group: group, spent_cents: spent_cents }
  let!(:user) { group.users.create! attributes_for(:user) }
  let!(:group) { create :group }
  let!(:share) do
    expense.shares.create! attributes_for(:share).merge(user_id: user.id)
  end
  let!(:new_shares) { [new_share] }
  let!(:new_share) { build :share, multiplier: multiplier, expense: nil }
  let!(:new_share_user_group_relationship) do
    group.users << new_share.user
    new_share.user.user_group_relationships.for_group(group).first
  end
  let(:multiplier) { 2 }
  let(:spent_cents) { 10_00 }

  describe '#substract_old_shares_from_balances' do
    let(:result) { interactor.substract_old_shares_from_balances }

    it 'add shares to user balances' do
      result
      # adding to sharers balance
      expect(user.balance_for(group)).to eq share.total_price
    end
  end

  describe '#substract_spending_from_balance' do
    let(:result) { interactor.substract_spending_from_balance }

    it 'substracts previous expense spending from balance' do
      expense.spent = 10000 # update to new value

      result
      # removing from payer balance
      expect(expense.payer.balance_for(group)).to eq -Money.new(spent_cents)
    end
  end

  describe '#remove_old_shares_from_expense' do
    let(:result) { interactor.remove_old_shares_from_expense }

    it 'removes shares from expense' do
      expect {
        result
      }.to change(expense.shares, :count).by -1
    end
  end

  describe '#add_new_shares_to_expense' do
    let(:result) { interactor.add_new_shares_to_expense }
    let(:expected_price) { spent_cents / multiplier }

    it 'adds new shares to an expense' do
      expect {
        result
      }.to change(expense.shares, :count).by 1

      expect(expense.shares.last.single_price_cents).to eq expected_price
    end
  end

  describe '#add_new_shares_to_balances' do
    let(:result) do
      interactor.add_new_shares_to_expense
      interactor.add_new_shares_to_balances
    end

    it 'reduces sharing users balances by new shares total price' do
      result
      expect(new_share.user.balance_for(group)).to eq -new_share.total_price
    end
  end

  describe '#add_spending_to_balance' do
    let(:result) { interactor.add_spending_to_balance }

    it 'increases payer balance by spending' do
      result
      # removing from payer balance
      expect(expense.payer.balance_for(group)).to eq expense.spent
    end
  end
end