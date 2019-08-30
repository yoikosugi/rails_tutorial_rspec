require 'rails_helper'

RSpec.describe "site_layout", type: :system do
  describe "layout links" do
    it "リンクが正しく表示されている" do
      visit root_path
      expect(page).to have_current_path(root_path)
      expect(page).to have_link("Home", href: root_path) 
      expect(page).to have_link("Help", href: help_path)
      expect(page).to have_link("About", href: about_path)
      expect(page).to have_link("Contact", href: contact_path)
    end
  end
end
