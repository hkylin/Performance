require 'rails_helper'

RSpec.describe "Modifications", type: :request do
  describe "GET /modifications" do
    it "works! (now write some real specs)" do
      get modifications_path
      expect(response).to have_http_status(200)
    end
  end
end
