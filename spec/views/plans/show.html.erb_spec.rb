require 'rails_helper'

RSpec.describe "plans/show", type: :view do
  before(:each) do
    @plan = assign(:plan, Plan.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Investment Manager/)
    expect(rendered).to match(/A Class/)
    expect(rendered).to match(/B Class/)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/MyText/)
  end
end
