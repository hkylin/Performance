require 'rails_helper'

RSpec.describe "modifications/show", type: :view do
  before(:each) do
    @modification = assign(:modification, Modification.create!(
      :project => nil,
      :management_fee => "9.99",
      :rate => "9.99",
      :fee => "9.99",
      :notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/MyText/)
  end
end
