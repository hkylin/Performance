require 'rails_helper'

RSpec.describe "modifications/edit", type: :view do
  before(:each) do
    @modification = assign(:modification, Modification.create!(
      :project => nil,
      :management_fee => "9.99",
      :rate => "9.99",
      :fee => "9.99",
      :notes => "MyText"
    ))
  end

  it "renders the edit modification form" do
    render

    assert_select "form[action=?][method=?]", modification_path(@modification), "post" do

      assert_select "input#modification_project_id[name=?]", "modification[project_id]"

      assert_select "input#modification_management_fee[name=?]", "modification[management_fee]"

      assert_select "input#modification_rate[name=?]", "modification[rate]"

      assert_select "input#modification_fee[name=?]", "modification[fee]"

      assert_select "textarea#modification_notes[name=?]", "modification[notes]"
    end
  end
end
