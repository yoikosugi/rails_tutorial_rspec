require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper
  
  let(:user) { FactoryBot.create(:user) }

  # ログインメソッド
  def post_valid_information(remember_me = 0)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_me: remember_me
      }
    }
  end

  describe "GET /login" do
    it "ログイン成功" do
      get login_path
      post_valid_information

      expect(flash[:danger]).to be_falsey
      expect(is_logged_in?).to be_truthy
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
      expect(is_logged_in?).to be_falsey
    end

    it "remember_meにチェックをして、remember_tokenを保存する" do
      get login_path
      post_valid_information(1)

      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).to_not be_empty
    end

    it "remember_meにチェックをせず、remember_tokenを保存しない" do
      get login_path
      post_valid_information

      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).to be_nil
    end
  end

  describe "DELETE /logout" do
    it "ログイン後、ログアウトできる" do
      get login_path
      post_valid_information

      expect(is_logged_in?).to be_truthy
      delete logout_path
      expect(is_logged_in?).to be_falsey
    end

    it "2番目のウィンドウでログアウトする" do
      get login_path
      post_valid_information

      expect(is_logged_in?).to be_truthy
      delete logout_path
      expect(is_logged_in?).to be_falsey

      # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
      delete logout_path
      expect(is_logged_in?).to be_falsey
    end

    it "ログアウト後、remember_tokenを削除する" do
      get login_path
      post_valid_information(1)

      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).to_not be_empty

      delete logout_path

      expect(is_logged_in?).to be_falsey
      expect(cookies[:remember_token]).to be_empty
    end
  end
end
