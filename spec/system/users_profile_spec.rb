require 'rails_helper'

RSpec.describe "UsersProfile", type: :system do
  include ApplicationHelper
  
  let(:user) { FactoryBot.create(:user) }
  let!(:user_post) { FactoryBot.create_list(:user_post, 50, user: user) }

  describe "profile display" do
    it "profile画面が正しく表示される" do

      visit login_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(current_path).to eq user_path(user)

      expect(page).to have_title full_title(user.name)
      expect(page).to have_selector 'h1', text: user.name
      expect(page).to have_selector 'h1>img.gravatar'
      expect(page).to have_content user.microposts.count.to_s
      expect(page).to have_selector 'div.pagination'
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
  end
end
