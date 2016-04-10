# Project.all.each do |x|
# 	puts x.id if x.plan == nil
# end

# Modification.all.each do |x|
# 	puts x.id if x.project == nil
# end

# d=Department.find(8)
# d.projects.each do |project|
# 	puts project.name
# end

# User.find(4).my_projects.each do |project|
# 	puts project.name
# end 


# projects = Project.includes(:cooperations).where(department: :8,channel_cost: )






# puts '--------111--------'
# projects = Project.includes(:cooperations).where.not(user: self).where(cooperations:{user: self})
# projects.each do |project|
# 	puts project.name
# end 

# puts '--------test cc--------'
# Project.cc.each do |project|
# 	puts project.name
# end 

# puts '--------test 22--------'
# Department.find(8).projects.cc.each do |project|
# 	puts project.name
# end 

# puts '--------members--------'
# puts Department.find(8).members.collect{|x| puts x.name}
# puts Department.find(8).members.size
# puts '--------staff--------'
# puts Department.find(8).staff.collect{|x| puts x.name}
# puts Department.find(8).staff.size
# puts '--------admins--------'
# puts Department.find(8).admins.collect{|x| puts x.name}
# puts Department.find(8).admins.size


puts Department.find(8).count_income Date.one_year
# puts Department.find(8).admins[0].count_income Date.one_year

hlw=Department.find(8)

puts hlw.count_plans_scale(Date.current)
puts hlw.count_inproject_outuser_scale(Date.current)
puts hlw.count_outproject_inuser_scale(Date.current)

puts hlw.count_scale2(Date.current)

puts hlw.count_plans_income(Date.since_this_year)
puts hlw.count_inproject_outuser_income(Date.since_this_year)
puts hlw.count_outproject_inuser_income(Date.since_this_year)

puts hlw.count_income2(Date.since_this_year)