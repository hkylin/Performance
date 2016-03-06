require "rails_helper"

RSpec.describe ProjectModificationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/project_modifications").to route_to("project_modifications#index")
    end

    it "routes to #new" do
      expect(:get => "/project_modifications/new").to route_to("project_modifications#new")
    end

    it "routes to #show" do
      expect(:get => "/project_modifications/1").to route_to("project_modifications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/project_modifications/1/edit").to route_to("project_modifications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/project_modifications").to route_to("project_modifications#create")
    end

    it "routes to #update" do
      expect(:put => "/project_modifications/1").to route_to("project_modifications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/project_modifications/1").to route_to("project_modifications#destroy", :id => "1")
    end

  end
end
