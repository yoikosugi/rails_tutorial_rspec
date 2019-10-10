require 'rails_helper'

RSpec.describe "RelationshipsController", type: :request do

  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, :other_user) }

  describe "POST /relationships" do
    context "ログインしていないとき" do
      it "/loginにリダイレクトする" do
        expect {
          post relationships_path
        }.to_not change(Relationship, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end

    context "ログイン時" do
      
      before do
        log_in_as(user)
      end
      
      it "ユーザーをフォローする" do
        expect {
          post relationships_path, params: { followed_id: other_user.id }
        }.to change(Relationship, :count).by(1)
      end

      it "Ajaxでユーザーをフォローする" do
        expect {
          post relationships_path, xhr: true, params: { followed_id: other_user.id }
        }.to change(Relationship, :count).by(1)
      end
    end
  end

  describe "DELETE /relationship/:id" do
    context "ログインしていないとき" do

      let!(:active) { FactoryBot.create(:relationship) }

      it "/loginにリダイレクトする" do
        expect {
          delete relationship_path(active)
        }.to_not change(Relationship, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end

    context "ログイン時" do

      before do
        log_in_as(user)
      end

      it "ユーザーをフォロー解除する" do
        user.follow(other_user)
        relationship = user.active_relationships.find_by(followed_id: other_user.id)
        expect {
          delete relationship_path(relationship)
        }.to change(Relationship, :count).by(-1)
      end

      it "Ajaxでユーザーをフォロー解除する" do
        user.follow(other_user)
        relationship = user.active_relationships.find_by(followed_id: other_user.id)
        expect {
          delete relationship_path(relationship), xhr: true
        }.to change(Relationship, :count).by(-1)
      end
    end
  end
end
