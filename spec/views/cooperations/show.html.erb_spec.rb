require 'rails_helper'

RSpec.describe "cooperations/show", type: :view do
  before(:each) do
    @cooperation = assign(:cooperation, Cooperation.create!(
      :user => nil,
      :modification => nil,
      :ratio => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
