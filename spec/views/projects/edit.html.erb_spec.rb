require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :plan => nil,
      :number => 1,
      :name => "MyString",
      :this_amount => "9.99",
      :year_amount => "9.99",
      :management_fee => "9.99",
      :investment_manager => "MyString",
      :a_class => "MyString",
      :b_class => "MyString",
      :department => nil,
      :rate => "9.99",
      :fee => "9.99",
      :notes => "MyText"
    ))
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do

      assert_select "input#project_plan_id[name=?]", "project[plan_id]"

      assert_select "input#project_number[name=?]", "project[number]"

      assert_select "input#project_name[name=?]", "project[name]"

      assert_select "input#project_this_amount[name=?]", "project[this_amount]"

      assert_select "input#project_year_amount[name=?]", "project[year_amount]"

      assert_select "input#project_management_fee[name=?]", "project[management_fee]"

      assert_select "input#project_investment_manager[name=?]", "project[investment_manager]"

      assert_select "input#project_a_class[name=?]", "project[a_class]"

      assert_select "input#project_b_class[name=?]", "project[b_class]"

      assert_select "input#project_department_id[name=?]", "project[department_id]"

      assert_select "input#project_rate[name=?]", "project[rate]"

      assert_select "input#project_fee[name=?]", "project[fee]"

      assert_select "textarea#project_notes[name=?]", "project[notes]"
    end
  end
end
