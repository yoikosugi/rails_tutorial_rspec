require 'rails_helper'

RSpec.describe "StaticPagesControllers", type: :request do
  describe "root" do
    it "should get root" do
      get root_path
      expect(response).to be_success
    end
  end

  describe "#home" do
    it "should get home" do
      get static_pages_home_url
      expect(response).to be_success
    end
  end

  describe "#help" do
    it "should get help" do
      get static_pages_help_url
      expect(response).to be_success
    end
  end

  describe "#about" do
    it "should get about" do
      get static_pages_about_url
      expect(response).to be_success
    end
  end

  describe "#contact" do
    it "should get contact" do
      get static_pages_contact_url
      expect(response).to be_success
    end
  end
end
