require 'rails_helper'

RSpec.describe "UsersDestroy", type: :system do
  describe "#destroy" do
    
    let(:admin) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create_list(:user, 3, :other_user) }

    context "admin" do
      xit "userの削除に成功する" do
        visit root_path
        click_link "Log in"
        fill_in "Email", with: admin.email
        fill_in "Password", with: admin.password
        click_button "Log in"

        expect(current_path).to eq user_path(admin)
        click_link "Users"
        expect(current_path).to eq users_path
        expect(page).to have_link('delete', href: user_path(other_user))
      end
    end

    context "non-admin" do
      it "userの削除に失敗する"
    end
  end
end
