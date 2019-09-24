require 'rails_helper'

RSpec.describe "UsersEdit", type: :system do

  let(:user) { FactoryBot.create(:user) }
  
  describe "無効な編集" do
    it "編集に失敗する" do
      visit root_path
      click_link "Log in"

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      click_link "Account"
      click_link "Settings"
      expect(current_path).to eq edit_user_path(user)

      fill_in "Name", with: ""
      fill_in "Email", with: "foo@invalid"
      fill_in "Password", with: "foo"
      fill_in "Confirmation", with: "bar"
      click_button "Save changes"

      expect(current_path).to eq user_path(user)
      expect(page).to have_css '.alert-danger', text: 'The form contains 4 errors.'
    end
  end

  describe "有効な編集" do
    it "編集に成功する" do
      visit root_path
      click_link "Log in"

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      click_link "Account"
      click_link "Settings"
      expect(current_path).to eq edit_user_path(user)

      fill_in "Name", with: "Foo Bar"
      fill_in "Email", with: "foo@bar.com"
      fill_in "Password", with: ""
      fill_in "Confirmation", with: ""
      click_button "Save changes"

      expect(current_path).to eq user_path(user)
      expect(page).to have_css '.alert-success', text: 'Profile updated'
    end
  end
end
