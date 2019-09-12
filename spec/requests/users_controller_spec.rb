require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  describe "#new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end
end
