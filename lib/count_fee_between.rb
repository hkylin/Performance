puts Plan.find(1).count_fee_between(Date.new(2014,1,1),Date.new(2016,7,1))
puts Plan.find(2).count_fee_between(Date.new(2014,1,1),Date.new(2016,7,1))
puts Plan.find(3).count_fee_between(Date.new(2014,1,1),Date.new(2016,7,1))
# puts Plan.find(4).count_fee_between(Date.new(2016,1,1),Date.new(2016,7,1))
puts '---------------------------------'
p1=Project.find(1)
puts p1.count_fee#20150204---20170204
puts p1.count_fee_between(Date.new(2016,1,1),Date.new(2016,7,1))
puts p1.count_fee_between(Date.new(2018,1,1),Date.new(2018,7,1))#右边 0
puts p1.count_fee_between(Date.new(2014,1,1),Date.new(2014,7,1))#左边 0
puts p1.count_fee_between(Date.new(2014,1,1),Date.new(2018,7,1))#包含 all
puts p1.count_fee_between(Date.new(2017,2,3),Date.new(2017,2,4))#左边 交叉
puts p1.count_fee_between(Date.new(2015,1,1),Date.new(2016,7,1))#左边 交叉
puts p1.count_fee_between(Date.new(2016,1,1),Date.new(2019,7,1))#右边 交叉



puts '---------------------------------'
p2=Project.find(2)
puts p2.count_fee_between(Date.new(2016,1,1),Date.new(2016,7,1))
puts p2.count_fee_between(Date.new(2016,1,1),Date.new(2010,7,1))
puts p2.count_fee_between(Date.new(2014,1,1),Date.new(2014,7,1))
puts p2.count_fee_between(Date.new(2014,1,1),Date.new(2020,7,1))
puts p2.count_fee


# --------------------------------
# 801095.890410958904109589
# 199452.054794520547945205
# 0.0
# 0.0
# 801095.890410958904109589
# 1095.890410958904109589
# 562191.780821917808219178
# 438356.164383561643835616
# ---------------------------------
# 199452.054794520547945205
# 0
# 161095.890410958904109589
# 1433424.657534246575342466
# 1433424.657534246575342466