require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper
  
  let(:user) { FactoryBot.create(:user) }

  describe "GET /login" do
    it "ログイン成功" do
      get login_path
      post login_path, params: {
        session: {
          email: user.email,
          password: user.password
        }
      }
      expect(flash[:danger]).to be_falsey
      expect(logged_in?).to be_truthy
    end

    it "ログイン失敗、エラーメッセージがでる" do
      get login_path
      post login_path, params: {
        session: {
          email: "",
          password: ""
        }
      }
      expect(flash[:danger]).to be_truthy
      expect(logged_in?).to be_falsey
    end
  end

  describe "DELETE /logout" do
    it "ログイン後、ログアウトできる" do
      get login_path
      post login_path, params: {
        session: {
          email: user.email,
          password: user.password
        }
      }
      expect(is_logged_in?).to be_truthy
      delete logout_path
      expect(is_logged_in?).to be_falsey
    end
  end
end
