require 'rails_helper'

RSpec.describe "project_modifications/edit", type: :view do
  before(:each) do
    @project_modification = assign(:project_modification, ProjectModification.create!(
      :project => nil,
      :management_fee => "9.99",
      :rate => "9.99",
      :fee => "9.99",
      :notes => "MyText"
    ))
  end

  it "renders the edit project_modification form" do
    render

    assert_select "form[action=?][method=?]", project_modification_path(@project_modification), "post" do

      assert_select "input#project_modification_project_id[name=?]", "project_modification[project_id]"

      assert_select "input#project_modification_management_fee[name=?]", "project_modification[management_fee]"

      assert_select "input#project_modification_rate[name=?]", "project_modification[rate]"

      assert_select "input#project_modification_fee[name=?]", "project_modification[fee]"

      assert_select "textarea#project_modification_notes[name=?]", "project_modification[notes]"
    end
  end
end
