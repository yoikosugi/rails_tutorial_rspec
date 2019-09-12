require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe "#new" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end
end
