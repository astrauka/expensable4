require 'spec_helper'

describe CreateMemberInvites do
  let(:interactor) { described_class.new(current_user, group, invited_user_fb_ids) }
  let(:current_user) { group.users.create!(attributes_for(:user)) }
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

    context 'on user already in the system' do
      let!(:identity) { create(:identity, uid: user_fb_id, user: invited_user) }
      let(:invited_user) { create(:user) }

      it 'assigns the user to group' do
        expect(invited_user.groups).to_not include group
        result
        expect(invited_user.reload.groups).to include group
      end
    end
  end

  describe '#notify_user' do
    let(:result) { interactor.notify_user(invite) }
    let!(:invite) { create :identity,
                           user: current_user }

    it 'notifies user via email' do
      expect {
        result
      }.to change(ActionMailer::Base.deliveries, :size).by 1
    end
  end
end
