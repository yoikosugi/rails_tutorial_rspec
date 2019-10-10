require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, :other_user) }

  before do
    @relationship = Relationship.new(follower_id: user.id, followed_id: other_user.id)
  end

  describe "Relationship" do
    it "有効である" do
      expect(@relationship).to be_valid
    end

    it "ユーザーをfollow&unfollowする" do
      expect(user.following?(other_user)).to be_falsey 
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      expect(other_user.followers.include?(user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end

  describe "follower_id" do
    it "follower_idがnilのとき、無効" do
      @relationship.follower_id = nil
      expect(@relationship).to be_invalid
    end
  end

  describe "followed_id" do
    it "followed_idがnilのとき、無効" do
      @relationship.followed_id = nil
      expect(@relationship).to be_invalid
    end
  end
end
