require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation" do
    before do
      @user = FactoryBot.create(:user)
    end

    context "when user is valid" do
      it "should be valid with" do
        expect(@user).to be_valid
      end

      it "is valid with valid addresses" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
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
end
