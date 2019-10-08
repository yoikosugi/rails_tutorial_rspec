require 'rails_helper'

RSpec.describe "MicropostsInterface", type: :system do
  xdescribe "micropost interface" do
    
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user, :other_user)}

    it "無効な送信" do
      visit login_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(current_path).to eq user_path(user)
  
      expect{
        visit root_path
        fill_in 'Compose new micropost...', with: ""
        click_button "Post"
      }.to_not change(Micropost, :count)
      expect(page).to have_css("div.alert.alert-danger")
    end

    it "有効な送信" do
      visit login_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(current_path).to eq user_path(user)

      content = "This micropost really ties the room together"

      expect{
        visit root_path
        fill_in 'Compose new micropost...', with: content
        attach_file '.picture', 'spec/fixtures/rails.png'
        click_button "Post"
      }.to change(Micropost, :count).by(1)
      expect(page).to have_css("div.alert.alert-success", text: "Micropost created")
    end

    it "投稿の削除ができる" do
      visit login_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(current_path).to eq user_path(user)

      expect{
        visit root_path
        fill_in 'Compose new micropost...', with: "This micropost really ties the room together"
        click_button "Post"
      }.to change(Micropost, :count).by(1)
      expect(page).to have_css("div.alert.alert-success", text: "Micropost created")

      expect{
        visit root_path
        click_link "delete", match: :first
      }.to change(Micropost, :count).by(-1)
      expect(page).to have_css("div.alert.alert-success", text: "Micropost deleted")
    end

    xit "違うユーザーのプロフィールにアクセス" do
      visit login_path
      click_link "Log in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(current_path).to eq user_path(user)


    end
  end
end