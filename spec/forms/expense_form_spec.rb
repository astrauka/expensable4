require 'spec_helper'

describe ExpenseForm do
  let(:form) { described_class.new(user, group, params) }
  let!(:user) { create :user }
  let!(:group) { create :group }
  let!(:expense) { create :expense, group: group }
  let(:params) do
    {
      expense_id: expense_id.to_s,
      expense: {
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
  let(:spent) { 14_00 }
  let(:payer) { create :user }
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
    let!(:expense_share) { create :share, expense: expense }

    it "returns expense shares and built shares for all the active users" do
      expect(result).to include expense_share
      expect(result.size).to eq 2
    end
  end

  describe "#shares_to_be_persisted" do
    let(:result) { form.shares_to_be_persisted }

    it "returns shares to be persisted" do
      expect(result.size).to eq 1
      expect(result.first.user_id).to eq share_user.id
    end
  end
end
