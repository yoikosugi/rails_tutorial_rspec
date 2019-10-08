require 'rails_helper'

RSpec.describe "MicropostsController", type: :request do
  describe "authorization" do

    let!(:micropost) { FactoryBot.create(:user_post)}

    context "ログインしていないとき" do
      it "createしようとすると、ログインページにリダイレクトする" do
        expect{
          post microposts_path, params: {
            micropost: {
              content: "Lorem ipsum"
            }
          }
        }.to_not change(Micropost, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end

      it "destroyしようとすると、ログインページにリダイレクトする" do
        expect{
          delete micropost_path(micropost)
        }.to_not change(Micropost, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end
  end

  describe "#destroy" do

    let(:user) { FactoryBot.create(:user) }
    let(:other_user_post) { FactoryBot.create(:user_post, :other_user_post)}

    context "wrong micropost" do
      it "destroyしようとすると、rootにリダイレクトする" do
        log_in_as(user)
        micropost = other_user_post
        expect{
          delete micropost_path(micropost)
        }.to_not change(Micropost, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
  end
end
