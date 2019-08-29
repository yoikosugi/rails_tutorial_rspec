require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  before do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "home" do
    it "ページタイトルが正しく表示されている" do
      visit static_pages_home_url
      expect(page).to have_title "Home | #{@base_title}"
    end
  end

  describe "help" do
    it "ページタイトルが正しく表示されている" do
      visit static_pages_help_url
      expect(page).to have_title "Help | #{@base_title}"
    end
  end

  describe "about" do
    it "ページタイトルが正しく表示されている" do
      visit static_pages_about_url
      expect(page).to have_title "About | #{@base_title}"
    end
  end

  describe "contact" do
    it "ページタイトルが正しく表示されている" do
      visit static_pages_contact_url
      expect(page).to have_title "Contact | #{@base_title}"
    end
  end
end
