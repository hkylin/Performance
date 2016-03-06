require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
        :plan => nil,
        :number => 1,
        :name => "Name",
        :this_amount => "9.99",
        :year_amount => "9.99",
        :management_fee => "9.99",
        :investment_manager => "Investment Manager",
        :a_class => "A Class",
        :b_class => "B Class",
        :department => nil,
        :rate => "9.99",
        :fee => "9.99",
        :notes => "MyText"
      ),
      Project.create!(
        :plan => nil,
        :number => 1,
        :name => "Name",
        :this_amount => "9.99",
        :year_amount => "9.99",
        :management_fee => "9.99",
        :investment_manager => "Investment Manager",
        :a_class => "A Class",
        :b_class => "B Class",
        :department => nil,
        :rate => "9.99",
        :fee => "9.99",
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of projects" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Investment Manager".to_s, :count => 2
    assert_select "tr>td", :text => "A Class".to_s, :count => 2
    assert_select "tr>td", :text => "B Class".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
