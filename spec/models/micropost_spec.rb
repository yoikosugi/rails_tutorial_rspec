require 'rails_helper'

RSpec.describe Micropost, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:user_post) { FactoryBot.build(:user_post) }

  describe "Micropost" do
    it "有効である" do
      expect(user_post).to be_valid
    end
  end

  describe "user_id" do
    it "idが存在しないとき、無効" do
      user_post.user_id = nil
      expect(user_post).to be_invalid
    end
  end

  describe "content" do
    it "contentが存在しないとき、無効" do
      user_post.content = "   "
      expect(user_post).to be_invalid
    end

    it "contentが140文字以上の時、無効" do
      user_post.content = "a" * 141
      expect(user_post).to be_invalid
    end
  end

  describe "default scope" do
    it "最も新しいものを最初に表示する" do
      old_post = user.microposts.create(content: "old", created_at: 1.day.ago)
      new_post = user.microposts.create(content: "new", created_at: Time.zone.now)
      expect(user.microposts.count).to eq 2
      expect(Micropost.all.count).to eq user.microposts.count
      expect(Micropost.first).to eq new_post
    end
  end
end
