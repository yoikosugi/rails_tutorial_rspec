require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do

  before do
    @user = FactoryBot.create(:user)
  end

  describe "ログイン" do
    it "ログインに成功すること" do
      visit root_path
      click_link "Log in"

      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"

      expect(current_path).to eq user_path(@user)
      expect(page).to_not have_link 'Log in', href: login_path

      # click_link "Account"
      within ".navbar-nav" do
        expect(page).to have_link 'Log out', href: logout_path
        expect(page).to have_link 'Profile', href: user_path(@user)
      end
    end

    it "ログインに失敗すること" do
      visit root_path
      click_link "Log in"

      fill_in "Email", with: ""
      fill_in "Password", with: ""
      click_button "Log in"

      expect(page).to have_css ".alert-danger"

      visit root_path
      expect(page).to_not have_css ".alert-danger"
    end
  end

  describe "ログアウト" do
    it "ログアウトすること" do
      # ログインする
      visit root_path
      click_link "Log in"

      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"

      expect(current_path).to eq user_path(@user)
      expect(page).to_not have_link "Log in", href: login_path

      within ".navbar-nav" do
        expect(page).to have_link "Log out", href: logout_path
        expect(page).to have_link "Profile", href: user_path(@user)
      end

      # ログインした状態から、ログアウトする
      click_link "Log out"
      expect(current_path).to eq root_path

      expect(page).to have_link "Log in", href: login_path
      expect(page).to_not have_link "Log out", href: logout_path
      expect(page).to_not have_link "Profile", href: user_path(@user)
    end
  end
end
