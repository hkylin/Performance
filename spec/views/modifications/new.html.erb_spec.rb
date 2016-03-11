require 'rails_helper'

RSpec.describe "modifications/new", type: :view do
  before(:each) do
    assign(:modification, Modification.new(
      :project => nil,
      :management_fee => "9.99",
      :rate => "9.99",
      :fee => "9.99",
      :notes => "MyText"
    ))
  end

  it "renders new modification form" do
    render

    assert_select "form[action=?][method=?]", modifications_path, "post" do

      assert_select "input#modification_project_id[name=?]", "modification[project_id]"

      assert_select "input#modification_management_fee[name=?]", "modification[management_fee]"

      assert_select "input#modification_rate[name=?]", "modification[rate]"

      assert_select "input#modification_fee[name=?]", "modification[fee]"

      assert_select "textarea#modification_notes[name=?]", "modification[notes]"
    end
  end
end
