require 'rails_helper'

RSpec.describe "UsersIndex", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe "#index" do
    it "indexにpaginationが含まれている" do
      visit root_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      expect(current_path).to eq user_path(user)
      click_link "Users"
      expect(current_path).to eq users_path
      expect(page).to have_title("All users")
      expect(page).to have_css("h1", text: "All users")
      User.paginate(page: 1).each do |user|
        expect(page).to have_css "li", text: user.name
      end
    end
  end
end
