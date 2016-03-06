Project.all.each do |x|
	puts x.id if x.plan == nil
end

ProjectModification.all.each do |x|
	puts x.id if x.project == nil
end