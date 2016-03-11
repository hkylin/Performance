require 'rails_helper'

RSpec.describe "cooperations/edit", type: :view do
  before(:each) do
    @cooperation = assign(:cooperation, Cooperation.create!(
      :user => nil,
      :modification => nil,
      :ratio => "9.99"
    ))
  end

  it "renders the edit cooperation form" do
    render

    assert_select "form[action=?][method=?]", cooperation_path(@cooperation), "post" do

      assert_select "input#cooperation_user_id[name=?]", "cooperation[user_id]"

      assert_select "input#cooperation_modification_id[name=?]", "cooperation[modification_id]"

      assert_select "input#cooperation_ratio[name=?]", "cooperation[ratio]"
    end
  end
end
