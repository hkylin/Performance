require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    assign(:task, Task.new(
      :name => "MyString",
      :task_type => "MyString",
      :amount => 1,
      :profit => "9.99",
      :description => "MyText"
    ))
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", tasks_path, "post" do

      assert_select "input#task_name[name=?]", "task[name]"

      assert_select "input#task_task_type[name=?]", "task[task_type]"

      assert_select "input#task_amount[name=?]", "task[amount]"

      assert_select "input#task_profit[name=?]", "task[profit]"

      assert_select "textarea#task_description[name=?]", "task[description]"
    end
  end
end
