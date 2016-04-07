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
puts '--------111--------'
projects = Project.includes(:cooperations).where.not(user: self).where(cooperations:{user: self})
projects.each do |project|
	puts project.name
end 

puts '--------test cc--------'
Project.cc.each do |project|
	puts project.name
end 

puts '--------test 22--------'
Department.find(8).projects.cc.each do |project|
	puts project.name
end 