require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do

  let(:user) { FactoryBot.create(:user) }

  describe "#current_user" do
    it "sessionがnilのとき、正しいユーザーを返す" do
      remember(user)
      expect(current_user).to eq user
      expect(is_logged_in?).to be_truthy
    end

    it "remember_digestが間違っていると、nilを返す" do
      remember(user)
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end
