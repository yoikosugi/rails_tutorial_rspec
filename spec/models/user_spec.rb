require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = FactoryBot.create(:user)
  end

  describe "validation" do
    context "when user is valid" do
      it "should be valid with" do
        expect(@user).to be_valid
      end

      it "is valid with valid addresses" do
        valid_addresses = %w[test@example.com USER@foo.COM A_US-ER@foo.bar.org 
                    first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    context "when user is invalid" do
      it "is invalid without a name" do
        @user.name = "   "
        expect(@user).to_not be_valid
      end

      it "is invalid without a email" do
        @user.email = "   "
        expect(@user).to_not be_valid
      end

      it "is invalid with a too long name" do
        @user.name = "a" * 51
        expect(@user).to_not be_valid
      end

      it "is invalid with a too long email" do
        @user.email = "a" * 244 + "@example.com"
        expect(@user).to_not be_valid
      end

      it "is invalid with invalid addresses" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                      foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        invalid_addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).to_not be_valid
        end
      end

      it "is invalid with duplicate email" do
        duplicate_user = FactoryBot.build(:user, email: @user.email.upcase)
        expect(duplicate_user).to_not be_valid
      end

      it "パスワードは存在しなければならない（空白もダメ）" do
        @user.password = @user.password_confirmation = " " * 6
        expect(@user).to_not be_valid
      end

      it "パスワードは6文字以上でないといけない" do
        @user.password = @user.password_confirmation = "a" * 5
        expect(@user).to_not be_valid
      end
    end

    it "emailアドレスは小文字で保存される" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "User model methods" do
    context "authenticated?" do
      it "digestがnilのときfalseを返す" do
        expect(@user.authenticated?(:remember, '')).to be_falsey
      end
    end
  end

  describe "has_many dependent" do
    it "userが削除されると、userのmicropostsも削除される" do
      @user.save
      @user.microposts.create!(content: "Lorem ipsum")
      expect {
        @user.destroy
      }.to change(Micropost, :count).by(-1)
    end
  end

  describe "feed should have the right posts" do
    
    let(:user) { FactoryBot.create(:user, :other_user) }
    let(:unfollow_user) { FactoryBot.create(:user, :other_user) }
    let(:follow_user) { FactoryBot.create(:user, :other_user) }

    before do
      user.microposts.create(content: "aiueo")
      unfollow_user.microposts.create(content: "aiueo")
      follow_user.microposts.create(content: "aiueo")
      user.follow(follow_user)
    end
    
    it "フォローしているユーザーの投稿" do
      follow_user.microposts.each do |post_following|
        expect(user.feed.include?(post_following)).to be_truthy
      end
    end

    it "自分自身の投稿" do
      user.microposts.each do |post_self|
        expect(user.feed.include?(post_self)).to be_truthy
      end
    end

    it "フォローしていないユーザーの投稿" do
      unfollow_user.microposts.each do |post_unfollowed|
        expect(user.feed.include?(post_unfollowed)).to be_falsey
      end
    end
  end
end
