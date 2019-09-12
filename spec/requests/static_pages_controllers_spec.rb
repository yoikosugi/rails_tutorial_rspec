require 'rails_helper'

RSpec.describe "StaticPagesControllers", type: :request do
  describe "root" do
    it "returns http success" do
      get root_path
      expect(response).to be_success
    end
  end

  describe "#home" do
    it "returns http success" do
      get root_path
      expect(response).to be_success
    end
  end

  describe "#help" do
    it "returns http success" do
      get help_path
      expect(response).to be_success
    end
  end

  describe "#about" do
    it "returns http success" do
      get about_path
      expect(response).to be_success
    end
  end

  describe "#contact" do
    it "returns http success" do
      get contact_path
      expect(response).to be_success
    end
  end
end
