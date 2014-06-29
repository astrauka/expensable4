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

  describe "#persist_group" do
    let(:result) { interactor.persist_group }

    it "persists the group" do
      result
      expect(interactor.group).to be_persisted
    end

    it "persists user group relationship" do
      result
      expect(interactor.user.groups.count).to eq 1
      expect(interactor.group.users).to eq [user]
    end

    it 'stores group creator' do
      result
      expect(interactor.group.creator).to eq user
    end

    context "on failure" do
      let(:group_name) { "" }

      it "throws exception" do
        expect {
          result
        }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe "#run" do
    let(:result) { interactor.run }

    it "records success" do
      expect(result.group).to be_kind_of Group
      expect(result).to be_success
    end

    context "on group persist failure" do
      let(:group_name) { "" }

      it "records failure" do
        expect(result.group).to be_kind_of Group
        expect(result).to_not be_success
      end
    end
  end
end
