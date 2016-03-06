require "rails_helper"

RSpec.describe CooperationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cooperations").to route_to("cooperations#index")
    end

    it "routes to #new" do
      expect(:get => "/cooperations/new").to route_to("cooperations#new")
    end

    it "routes to #show" do
      expect(:get => "/cooperations/1").to route_to("cooperations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/cooperations/1/edit").to route_to("cooperations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/cooperations").to route_to("cooperations#create")
    end

    it "routes to #update" do
      expect(:put => "/cooperations/1").to route_to("cooperations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/cooperations/1").to route_to("cooperations#destroy", :id => "1")
    end

  end
end
