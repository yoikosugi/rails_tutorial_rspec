require 'rails_helper'

RSpec.describe "UsersController", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, :other_user) }

  describe "#new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "#index" do
    it "returns http success" do
      log_in_as(user)
      get users_path(user)
      expect(response).to have_http_status(:success)
    end

    it "未ログイン時、login画面にリダイレクトする" do
      get users_path(user)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
    end
  end
end
