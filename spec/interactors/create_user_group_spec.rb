require 'spec_helper'

describe CreateUserGroup do
  let(:interactor) { described_class.new(user, group_params) }
  let(:user) { create :user }
  let(:group_params) do
    {
      name: group_name,
    }
  end
  let(:group_name) { "Personal" }

  describe "#group" do
    let(:result) { interactor.group }

    it "persists the group" do
      result
      expect(interactor.group).to be_persisted
    end

    it "persists user group relationship" do
      result
      expect(interactor.user.groups.count).to eq 1
      expect(interactor.group.users).to eq [user]
    end
  end
end
