require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  before do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "home" do
    it "ページタイトルが正しく表示されている" do
      visit root_path
      expect(page).to have_title "#{@base_title}"
    end
  end

  describe "help" do
    it "ページタイトルが正しく表示されている" do
      visit help_path
      expect(page).to have_title "Help | #{@base_title}"
    end
  end

  describe "about" do
    it "ページタイトルが正しく表示されている" do
      visit about_path
      expect(page).to have_title "About | #{@base_title}"
    end
  end

  describe "contact" do
    it "ページタイトルが正しく表示されている" do
      visit contact_path
      expect(page).to have_title "Contact | #{@base_title}"
    end
  end
end
