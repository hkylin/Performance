require 'rails_helper'

RSpec.describe "ProjectModifications", type: :request do
  describe "GET /project_modifications" do
    it "works! (now write some real specs)" do
      get project_modifications_path
      expect(response).to have_http_status(200)
    end
  end
end
