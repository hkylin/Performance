require 'rails_helper'

RSpec.describe "plans/new", type: :view do
  before(:each) do
    assign(:plan, Plan.new(
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

  it "renders new plan form" do
    render

    assert_select "form[action=?][method=?]", plans_path, "post" do

      assert_select "input#plan_number[name=?]", "plan[number]"

      assert_select "input#plan_name[name=?]", "plan[name]"

      assert_select "input#plan_this_amount[name=?]", "plan[this_amount]"

      assert_select "input#plan_year_amount[name=?]", "plan[year_amount]"

      assert_select "input#plan_management_fee[name=?]", "plan[management_fee]"

      assert_select "input#plan_investment_manager[name=?]", "plan[investment_manager]"

      assert_select "input#plan_a_class[name=?]", "plan[a_class]"

      assert_select "input#plan_b_class[name=?]", "plan[b_class]"

      assert_select "input#plan_department_id[name=?]", "plan[department_id]"

      assert_select "input#plan_rate[name=?]", "plan[rate]"

      assert_select "input#plan_fee[name=?]", "plan[fee]"

      assert_select "textarea#plan_notes[name=?]", "plan[notes]"
    end
  end
end
