require 'rails_helper'

RSpec.describe "project_modifications/index", type: :view do
  before(:each) do
    assign(:project_modifications, [
      ProjectModification.create!(
        :project => nil,
        :management_fee => "9.99",
        :rate => "9.99",
        :fee => "9.99",
        :notes => "MyText"
      ),
      ProjectModification.create!(
        :project => nil,
        :management_fee => "9.99",
        :rate => "9.99",
        :fee => "9.99",
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of project_modifications" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
