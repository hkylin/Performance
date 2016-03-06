require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!(
      :name => "MyString",
      :task_type => "MyString",
      :amount => 1,
      :profit => "9.99",
      :description => "MyText"
    ))
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(@task), "post" do

      assert_select "input#task_name[name=?]", "task[name]"

      assert_select "input#task_task_type[name=?]", "task[task_type]"

      assert_select "input#task_amount[name=?]", "task[amount]"

      assert_select "input#task_profit[name=?]", "task[profit]"

      assert_select "textarea#task_description[name=?]", "task[description]"
    end
  end
end
