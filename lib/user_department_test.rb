def puts_user_department(email)
	magq=User.find_by_email email
	puts magq.email
	magq.admin_departments.each {|x|  puts x.name}
end


puts_user_department('maguoqing@msjyamc.com.cn')
puts_user_department('mahuijun@msjyamc.com.cn')
puts_user_department('jinguorui@msjyamc.com.cn')
puts_user_department('zhangyajun@msjyamc.com.cn')


puts "-----互联网金融部-----"
puts "-----admin-----"
hlw=Department.find_by_name('互联网金融部')
hlw.admins.each do |x|
	puts x.email
end
puts "-----members-----"
hlw.members.each do |x|
	puts x.email
end
puts "-----starff-----"
hlw.staff.each do |x|
	puts x.email
end

puts "-----财富管理事业部-----"
puts "-----admin-----"
cf=Department.find_by_name('财富管理事业部')
cf.admins.each do |x|
	puts x.email
end
puts "-----members-----"
cf.members.each do |x|
	puts x.email
end

puts "-----staff-----"
cf.staff.each do |x|
	puts x.email
end