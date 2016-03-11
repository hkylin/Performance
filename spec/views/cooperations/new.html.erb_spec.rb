require 'rails_helper'

RSpec.describe "cooperations/new", type: :view do
  before(:each) do
    assign(:cooperation, Cooperation.new(
      :user => nil,
      :modification => nil,
      :ratio => "9.99"
    ))
  end

  it "renders new cooperation form" do
    render

    assert_select "form[action=?][method=?]", cooperations_path, "post" do

      assert_select "input#cooperation_user_id[name=?]", "cooperation[user_id]"

      assert_select "input#cooperation_modification_id[name=?]", "cooperation[modification_id]"

      assert_select "input#cooperation_ratio[name=?]", "cooperation[ratio]"
    end
  end
end
