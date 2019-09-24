require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:archer) { FactoryBot.create(:user, :archer) }

  describe "GET /edit" do

    context "無効" do
      it "編集に失敗する" do
        log_in_as(user)
        expect(is_logged_in?).to be_truthy

        get edit_user_path(user)
        expect(request.fullpath).to eq '/users/1/edit'

        patch user_path(user), params: {
          user: {
            name: "",
            email: "foo@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        }
        expect(request.fullpath).to eq '/users/1'
      end
    end

    context "有効" do
      it "編集に成功する" do
        log_in_as(user)
        expect(is_logged_in?).to be_truthy

        get edit_user_path(user)
        expect(request.fullpath).to eq '/users/1/edit'

        patch user_path(user), params: {
          user: {
            name: "Foo Bar",
            email: "foo@bar.com",
            password: "",
            password_confirmation: ""
          }
        }
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/users/1"
        user.reload
        expect(user.name).to eq "Foo Bar"
        expect(user.email).to eq "foo@bar.com"
      end
    end

    context "ログインしていないとき" do
      it "get editすると、リダイレクトされる" do
        get edit_user_path(user)
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end

      it "patch updateすると、リダイレクトされる" do
        patch user_path(user), params: {
          user: {
            name: "Foo Bar",
            email: "foo@bar.com",
            password: "",
            password_confirmation: ""
          }
        }
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end

      it "フレンドリーフォワーディング" do
        get edit_user_path(user)
        log_in_as(user)
        follow_redirect!
        expect(request.fullpath).to eq '/users/1/edit'
        patch user_path(user), params: {
          user: {
            name: "Foo Bar",
            email: "foo@bar.com",
            password: "",
            password_confirmation: ""
          }
        }
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq '/users/1'
        user.reload
        expect(user.name).to eq "Foo Bar"
        expect(user.email).to eq "foo@bar.com"
      end
    end

    context "間違ったユーザーが編集しようとするとき" do
      it "get editすると、リダイレクトされる" do
        log_in_as(archer)
        get edit_user_path(user)
        expect(flash[:danger]).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end

      it "patch updateすると、リダイレクトされる" do
        log_in_as(archer)
        patch user_path(user), params: {
          user: {
            name: "Foo Bar",
            email: "foo@bar.com",
            password: "",
            password_confirmation: ""
          }
        }
        expect(flash[:danger]).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end

      it "admin属性の変更を許可しない" do
        log_in_as(archer)
        expect(archer.admin?).to be_falsey
        patch user_path(archer), params: {
          user: {
            password: archer.password,
            password_confirmation: archer.password,
            admin: true
          }
        }
        expect(archer.reload.admin?).to be_falsey
      end
    end
  end
end
