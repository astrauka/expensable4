require 'spec_helper'

describe AuthenticateViaFacebook do
  let(:interactor) { described_class.new(auth) }
  let(:auth) do
    {
      "provider" => provider,
      "uid" => uid,
      "info" => {
        "nickname" => "nick",
        "email" => "user@gmail.com",
        "name" => "John Budle",
        "first_name" => first_name,
        "last_name" => "Bundle",
        "image" => "http://graph.facebook.com/1184704/picture",
        "urls" => {
          "Facebook" => "https://www.facebook.com/nick"
        }
      }
    }
  end
  let(:uid) { "as123" }
  let(:provider) { "facebook" }
  let(:first_name) { "John" }

  describe "#identity" do
    let(:result) { interactor.identity }

    it "returns identity for authentication" do
      expect(result).to be_persisted
      expect(result.provider).to eq provider
      expect(result.uid).to eq uid
    end
  end

  describe "#create_or_update_user" do
    let(:result) { interactor.create_or_update_user }
    let!(:identity) { create :identity,
                             user: nil,
                             provider: provider,
                             uid: uid }

    context "When user does not exist" do
      it "Then creates a user" do
        expect {
          result
        }.to change(User, :count).by 1

        identity.reload
        expect(identity.user.first_name).to eq first_name
      end
    end

    context "When user exists" do
      let!(:user) { create :user, identity: identity }

      it "Then updates user with fb info" do
        expect(result.first_name).to eq first_name
      end
    end
  end
end
