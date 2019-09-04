require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "有効なユーザー登録" do
    it "ユーザー登録に成功する" do
      visit root_path
      click_link "Sign up now!"

      expect {
        fill_in "Name", with: "Example"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "test123"
        fill_in "Confirmation", with: "test123"
        click_button "Create my account"
      }.to change(User, :count).by(1)

      expect(page).to have_css ".alert-success"
    end
  end

  describe "無効なユーザー登録" do
    it "ユーザー登録に失敗する" do
      visit root_path
      click_link "Sign up now!"

      expect {
        fill_in "Name", with: ""
        fill_in "Email", with: "user@invalid"
        fill_in "Password", with: "foo"
        fill_in "Confirmation", with: "bar"
        click_button "Create my account"
      }.to change(User, :count).by(0)

      expect(current_path).to eq signup_path
      expect(page).to have_css "#error_explanation"
      expect(page).to have_css ".field_with_errors"
    end
  end
end
