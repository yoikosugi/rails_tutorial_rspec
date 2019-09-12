require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  include SessionsHelper

  describe "GET /signup" do
    xit "有効なユーザー登録" do
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
