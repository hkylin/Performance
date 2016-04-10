require 'rails_helper'

RSpec.describe Plan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  plan=Plan.find(1)
  puts plan.name
  puts plan.mobility_scale
end
