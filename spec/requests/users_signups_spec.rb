require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  include SessionsHelper

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "GET /signup" do
    it "有効なユーザー登録" do
      get signup_path
      expect {
        post signup_path, params: {
          user: {
            name: "Example User",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)
      expect(ActionMailer::Base.deliveries.size).to eq 1
      user = assigns(:user)
      expect(user.activated?).to be_falsey
      # 有効化していない状態でログインしてみる
      log_in_as(user)
      expect(is_logged_in?).to be_falsey
      # 有効化トークンが不正な場合
      get edit_account_activation_path("invalid token", email: user.email)
      expect(user.activated?).to be_falsey
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_path(user.activation_token, email: "wrong")
      expect(user.activated?).to be_falsey
      # 有効化トークンが正しい場合
      get edit_account_activation_path(user.activation_token, email: user.email)
      expect(user.reload.activated?).to be_truthy
      follow_redirect!
      expect(is_logged_in?).to be_truthy      
    end

    it "無効なユーザー登録" do
      get signup_path
      expect {
        post signup_path, params: {
          user: {
            name: "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        }
      }.to_not change(User, :count)
      expect(is_logged_in?).to be_falsey
    end
  end
end
