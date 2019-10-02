require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { FactoryBot.create(:user) }

  describe "POST /password_resets" do
    it "メールアドレスが無効" do
      get new_password_reset_path
      expect(request.fullpath).to eq '/password_resets/new'
      
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash[:danger]).to be_truthy
      expect(request.fullpath).to eq '/password_resets'
    end

    it "メールアドレスが有効" do
      get new_password_reset_path
      expect(request.fullpath).to eq '/password_resets/new'

      post password_resets_path, params: {
        password_reset: { email: user.email } 
      }
      expect(user.reset_digest).to_not eq user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(flash[:info]).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end
  end

  describe "GET /password_resets/:id/edit" do

    it "メールアドレスが無効" do
      post password_resets_path, params: {
        password_reset: { email: user.email}
      }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: "")
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end

    it "無効なユーザー" do
      post password_resets_path, params: {
        password_reset: { email: user.email }
      }
      user = assigns(:user)
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end

    it "メールアドレスが有効で、トークンが無効" do
      post password_resets_path, params: {
        password_reset: { email: user.email }
      }
      user = assigns(:user)
      get edit_password_reset_path('wrong token', email: user.email)
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end

    it "メールアドレスもトークンも有効" do
      post password_resets_path, params: {
        password_reset: { email: user.email }
      }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(request.fullpath).to eq "/password_resets/#{user.reset_token}/edit?email=#{CGI.escape(user.email)}"
    end
  end

  describe "PATCH /password_resets/:id" do
    it "無効なパスワードとパスワード確認" do
      post password_resets_path, params: {
        password_reset: { email: user.email }
      }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: "foobaz",
          password_confirmation: "barquux"
        }
      }
      expect(request.fullpath).to eq "/password_resets/#{user.reset_token}"
    end

    it "パスワードが空" do
      post password_resets_path, params: {
        password_reset: { email: user.email }
      }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: "",
          password_confirmation: ""
        }
      }
      expect(request.fullpath).to eq "/password_resets/#{user.reset_token}"
    end

    it "トークンが期限切れ" do
      post password_resets_path, params: {
        password_reset: { email: user.email }
      }
      user = assigns(:user)
      user.update_attribute(:reset_sent_at, 3.hours.ago)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: "foobaz",
          password_confirmation: "foobaz"
        }
      }
      expect(flash[:danger]).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/password_resets/new'
    end

    it "有効なパスワードとパスワード確認" do
      post password_resets_path, params: {
        password_reset: { email: user.email }
      }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: "foobaz",
          password_confirmation: "foobaz"
        }
      }
      expect(is_logged_in?).to be_truthy
      expect(flash[:success]).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq "/users/1"
    end
  end
end
