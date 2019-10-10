require 'rails_helper'

RSpec.describe "FollowingPageFollowersPage", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create_list(:user, 50, :other_user)}
  let!(:relationship) { FactoryBot.create_list(:relationship, 5)}
  let!(:passive) { FactoryBot.create_list(:relationship, 5, :passive) }

  describe "following page" do
    it "正しく表示される" do
      visit login_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(current_path).to eq user_path(user)

      visit following_user_path(user)
      expect(user.following).to_not be_empty
      expect(page).to have_content user.following.count.to_s
      user.following.each do |u|
        expect(page).to have_link u.name, user_path(u)
      end
    end
  end

  describe "followers page" do
    it "正しく表示される" do
      visit login_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(current_path).to eq user_path(user)

      visit followers_user_path(user)
      expect(user.followers).to_not be_empty
      expect(page).to have_content user.followers.count.to_s
      user.followers.each do |u|
        expect(page).to have_link u.name, user_path(u)
      end
    end
  end
end
