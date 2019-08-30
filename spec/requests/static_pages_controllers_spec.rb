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
      get root_path
      expect(response).to be_success
    end
  end

  describe "#help" do
    it "should get help" do
      get help_path
      expect(response).to be_success
    end
  end

  describe "#about" do
    it "should get about" do
      get about_path
      expect(response).to be_success
    end
  end

  describe "#contact" do
    it "should get contact" do
      get contact_path
      expect(response).to be_success
    end
  end
end
