require 'spec_helper'

describe ExpenseForm do
  let(:form) { described_class.new(user, group, params) }
  let!(:user) { create :user }
  let!(:group) { create :group }
  let!(:expense) { create :expense, group: group }
  let(:params) do
    {
      expense_id: expense_id.to_s,
      expense_attributes: {
        description: description,
        spent: spent,
        payer_id: payer.id.to_s,
        hidden: hidden,
      },
      shares_with_sharing_input_attributes: {
        "0" => {
          multiplier: "1",
          sharing: "0",
          user_id: user.id.to_s,
        },
        "1" => {
          multiplier: "1",
          sharing: "1",
          user_id: share_user.id.to_s
        }
      }
    }
  end
  let(:expense_id) { expense.id }
  let(:description) { "Dinner" }
  let(:spent) { 14.00 }
  let(:payer) { group.users.create! attributes_for(:user) }
  let(:hidden) { "0" }
  let(:share_user) { group.users.create! attributes_for(:user) }

  describe "#expense" do
    let(:result) { form.expense }

    context "When expense exists" do
      it "then finds the expense" do
        expect(result).to eq expense
      end
    end

    context "When expense does not exist" do
      let(:expense_id) { nil }

      it "Then initializes the expense" do
        expect(result).to be_instance_of Expense
      end
    end
  end

  describe "#new_shares" do
    let(:result) { form.new_shares }
    let!(:expense_share) { create :share, expense: expense, user: share_user, multiplier: 12 }

    it "returns expense share multipliers and built shares for new the active users" do
      expect(result.first.multiplier).to eq expense_share.multiplier
      expect(result.size).to eq 2
    end
  end

  describe "#shares_to_be_persisted" do
    let(:result) { form.shares_to_be_persisted }

    it "returns shares to be persisted" do
      expect(result.size).to eq 1
      expect(result.first.user_id).to eq share_user.id
      expect(result.first.multiplier).to eq 1
    end
  end

  describe '#save' do
    let(:result) { form.save }
    let(:params) do
      {
        expense_id: expense_id.to_s,
        expense_attributes: {
          description: description,
          spent: spent,
          payer_id: payer_id,
          hidden: hidden,
        },
        shares_with_sharing_input_attributes: {
          "0" => {
            multiplier: "2",
            sharing: "1",
            user_id: payer.id.to_s,
          },
          "1" => {
            multiplier: "1",
            sharing: "1",
            user_id: share_user.id.to_s
          }
        }
      }
    end
    let(:payer_id) { payer.id.to_s }
    let(:spent) { 15.00 }
    let(:payer_share) { form.expense.shares.for_user(payer).first }
    let(:share_user_share) { form.expense.shares.for_user(share_user).first }

    context 'on create' do
      let(:expense) { build :expense }

      it 'updates balances and creates shares' do
        result
        expect(payer.balance_for(group)).to eq spent / 3
        expect(share_user.balance_for(group)).to eq -(spent / 3)
        expect(payer_share.total_price).to eq spent / 3 * 2
        expect(share_user_share.total_price).to eq spent / 3
      end
    end

    context 'on update' do
      let!(:expense) { create :expense,
                             group: group,
                             spent_cents: 100_00,
                             creator: user,
                             payer: payer }
      let!(:payer_old_share) { create :share,
                                      expense: expense,
                                      user: payer,
                                      multiplier: 1,
                                      single_price_cents: 25_00 }
      let!(:share_user_new_share) { create :share,
                                           expense: expense,
                                           user: share_user,
                                           multiplier: 3,
                                           single_price_cents: 25_00 }
      let!(:payer_balance) {
        payer.user_group_relationships.first.update!(
          group: group,
          balance_cents: 75_00
        )
      }
      let!(:share_user_balance) {
        share_user.user_group_relationships.first.update!(
          group: group,
          balance_cents: -75_00
        )
      }
      let(:payer_id) { share_user.id.to_s }

      it 'updates balances and recreates shares' do
        result
        expect(payer.balance_for(group)).to eq -(spent / 3 * 2)
        expect(share_user.balance_for(group)).to eq spent / 3 * 2
        expect(payer_share.total_price).to eq spent / 3 * 2
        expect(share_user_share.total_price).to eq spent / 3
      end
    end
  end
end
