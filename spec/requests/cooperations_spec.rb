require 'rails_helper'

RSpec.describe "Cooperations", type: :request do
  describe "GET /cooperations" do
    it "works! (now write some real specs)" do
      get cooperations_path
      expect(response).to have_http_status(200)
    end
  end
end
