require "rails_helper"

RSpec.describe ModificationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/modifications").to route_to("modifications#index")
    end

    it "routes to #new" do
      expect(:get => "/modifications/new").to route_to("modifications#new")
    end

    it "routes to #show" do
      expect(:get => "/modifications/1").to route_to("modifications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/modifications/1/edit").to route_to("modifications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/modifications").to route_to("modifications#create")
    end

    it "routes to #update" do
      expect(:put => "/modifications/1").to route_to("modifications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/modifications/1").to route_to("modifications#destroy", :id => "1")
    end

  end
end
