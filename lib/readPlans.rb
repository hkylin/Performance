def runit
file=File.open("lib/2222.csv","r")
file.each do |line| 
	# print"#{file.lineno}.", line
	ls=line.split(',')
	puts "#{file.lineno}  #{ls.size}: #{ls}"
	pland=analyse_datas(ls,file)
	puts pland
	process(pland) if pland
end
file.close
end

# 0资产管理计划名称
# 1一对一or一对多
# 2起始日	
# 3到期日	 
# 4续存规模（元） 	
# 5管理费率（%）	 
# 6前后端收费金额 	
# 7前后端收费日期	
# 8业务部门	
# 9计息天数（360/365）	
# 10行内/行外	
# 11合作机构	
# 12模式

#整理excel数据
#分析数据，必须是13
def analyse_datas(ls,file)
	if (ls.size!=16 || ls[0]=='0')
		puts "#{file.lineno}, #{ls.size}, #{ls}"
	else
		plan=Plan.new  #只是作为一个数据结构，先将数据保存在这里。
		plan.name=getData(ls[1])
		plan.plan_type=getData(ls[2])
		plan.start_date=getData(ls[3])
		plan.end_date=getData(ls[4])
		plan.scale=getData(ls[5])
		plan.rate=getData(ls[6])
		plan.charge_amount=getData(ls[7])
		plan.charge_type= Plan::CHARGE_TYPE[1] unless(plan.charge_amount==nil)
		plan.charge_date=getData(ls[8])
		plan.department=getDepartment(ls[9])
		plan.annual=getData(ls[10])
		plan.ownership_type=getData(ls[11]) 
		plan.parter=getData(ls[12])    
		plan.model_type=getData(ls[13]) 
		plan.user=getUser(ls[14])
		plan.risk='正常'
		return plan
	end
end

def getDepartment(str)
	department=Department.find_by_name(getData(str))
end

def getUser(str)
	user=User.find_by_username(getData(str))
end
#分析数据字段  如果是-返回nil，如果不是按照正常数据处理
def getData(str)
	unless(str=='-')
		return str		
	else
		return nil
	end
end

def process(pland)
	m=Modification.find_by_name(pland.name)
	if(m)#Modify已经有同名的，必然是modify，所以
		createModification(pland)
	else
		plan = Plan.find_by_name(pland.name)	
		if(plan)
			copyPlanAndCreateNewOne(plan,pland)
		else
			createPlan(pland)
		end
	end
end

def createModification(pland)
	puts "createModification"
	liangfeng = User.find_by_email('liangfeng@msjyamc.com.cn')
	plan = Plan.find_by_name(pland.name)
	Modification.create!( modificationable: plan,user: liangfeng, name: pland.name, charge_type: pland.charge_type,charge_date: pland.charge_date,charge_amount: pland.charge_amount, risk: pland.risk, start_date: pland.start_date, end_date: pland.end_date,scale: pland.scale, rate: pland.rate, annual: pland.annual, channel_cost: 0.0)
end 

def createPlan(pland)
	puts "createPlan"
	pland.save!
end

def copyPlanAndCreateNewOne(plan,pland)
	puts "copyPlanAndCreateNewOne"
	createModification(plan)#复制计划作为第一个modify
	createModification(pland)
end

runit

# bb=BigDecimal.new（'0.10%'）
# puts bb


 # File.open("plans.txt","r") do |file|

 #   while line  = file.gets

 #       puts line #打印出文件内容

 #   end

 # end

 # plan7=Plan.create(name: '全权委托-普通收费4-有修改', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0],number: 10000051, user: mgq, department: hlw, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
# plan8=Plan.create(name: '全权委托-前收费4', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[1], ownership_type: Plan::OWNERSHIP_TYPE[1],charge_amount:10000, charge_date:'2016-2-1', number: 10000052, user: mgq, department: hlw, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
# plan9=Plan.create(name: '全权委托-后收费4', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[2], ownership_type: Plan::OWNERSHIP_TYPE[0],charge_amount:10000, charge_date:'2017-2-4', number: 10000053, user: mgq, department: hlw, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
# Modification.create( modificationable: plan7, user: mgq, charge_type: Plan::CHARGE_TYPE[1], charge_amount: 10000,  charge_date:'2016-2-1',  risk: :正常, start_date: '2016-2-1', end_date: '2016-10-4',scale: 100000000, rate: 0.004, annual: 365)
# Modification.create( modificationable: plan7, user: mgq, charge_type: Plan::CHARGE_TYPE[0], risk: :正常, start_date: '2016-10-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)


#TODO  赎回有表么？有表出表，不然别又和想象的不一致。
# modify 现在是不保存 模式、行内行外、合作伙伴，这些在modify中会改变么？不会改变就不在modify中增加了？

#数据准备：导出到逗号分隔的csv格式，ultraedit复制到sublime中。完成数据准备






