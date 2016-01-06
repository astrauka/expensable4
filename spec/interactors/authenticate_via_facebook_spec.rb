require 'spec_helper'

describe AuthenticateViaFacebook do
  let(:interactor) { described_class.new(auth) }
  let(:auth) do
    {
      'provider' => provider,
      'uid' => uid,
      'info' => {
        'nickname' => 'nick',
        'email' => 'user@gmail.com',
        'name' => [first_name, last_name].join(' '),
        'image' => 'http://graph.facebook.com/1184704/picture',
        'urls' => {
          'Facebook' => 'https://www.facebook.com/nick'
        }
      }
    }
  end
  let(:uid) { 'as123' }
  let(:provider) { 'facebook' }
  let(:first_name) { 'John' }
  let(:last_name) { 'Bullet' }

  describe '#identity' do
    let(:result) { interactor.identity }

    it 'returns identity for authentication' do
      expect(result).to be_persisted
      expect(result.provider).to eq provider
      expect(result.uid).to eq uid
    end
  end

  describe '#create_or_update_user' do
    let(:result) { interactor.create_or_update_user }
    let!(:identity) { create :identity,
                             user: nil,
                             provider: provider,
                             uid: uid }

    context 'When user does not exist' do
      it 'Then creates a user' do
        expect {
          result
        }.to change(User, :count).by 1

        identity.reload
        expect(identity.user.first_name).to eq first_name
      end
    end

    context 'When user exists' do
      let!(:user) { create :user, identity: identity }

      it 'Then updates user with fb info' do
        expect(result.first_name).to eq first_name
      end
    end
  end

  describe '#accept_invites' do
    let(:result) { interactor.run }
    let!(:new_invite) { create :invite, uid: uid }
    let!(:accepted_invite) { create :invite, :accepted, uid: uid }
    let!(:other_member_invite) { create :invite, uid: '123x' }
    let(:user_groups) { interactor.user.groups }

    it 'accepts all not accpepted invites' do
      result
      expect(user_groups).to include new_invite.group
      expect(user_groups).to_not include accepted_invite.group
      expect(user_groups).to_not include other_member_invite.group
    end
  end
end
