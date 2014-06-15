require 'spec_helper'

describe CreateMemberInvites do
  let(:interactor) { described_class.new(group, invited_user_fb_ids) }
  let(:group) { create :group }
  let(:invited_user_fb_ids) {
    [
      user_fb_id
    ]
  }
  let(:user_fb_id) { "13213" }

  describe "#create_invite" do
    let(:result) { interactor.create_invite(user_fb_id) }

    it "creates invite for the user" do
      expect(result.uid).to eq user_fb_id
      expect(result.accepted).to eq false
    end
  end

  describe "#run" do
    let(:result) { interactor.run }

    it "creates invites for user ids" do
      expect {
        result
      }.to change(Invite, :count).by 1

      expect(result).to be_success
    end
  end
end
