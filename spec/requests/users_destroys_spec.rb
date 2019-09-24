require 'rails_helper'

RSpec.describe "UsersDestroys", type: :request do

  let!(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, :other_user) }

  describe "#destroy" do
    context "ログインしていないとき" do
      it "deleteに失敗し、login画面にリダイレクトされる" do
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end
    
    context "adminがtrueのとき" do
      it "deleteに成功する" do
        log_in_as(user)
        expect {
          delete user_path(user)
        }.to change(User, :count).by(-1)
      end
    end

    context "adminがfalseのとき" do
      it "deleteに失敗し、root_urlにリダイレクトされる" do
        log_in_as(other_user)
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
  end
end
