require 'rails_helper'

RSpec.describe "cooperations/index", type: :view do
  before(:each) do
    assign(:cooperations, [
      Cooperation.create!(
        :user => nil,
        :modification => nil,
        :ratio => "9.99"
      ),
      Cooperation.create!(
        :user => nil,
        :modification => nil,
        :ratio => "9.99"
      )
    ])
  end

  it "renders a list of cooperations" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
