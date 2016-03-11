require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "should create a User" do
	#--date--
	mj=Department.create(name: '民生加银资产管理有限公司')
	yg=Department.create(name: '业务管理部', sup_department: mj)
	hlw=Department.create(name: '互联网金融部', sup_department: yg)
	jh=Department.create(name: '金融合作事业部', sup_department: mj)
	cjx=User.create(username: :陈金鑫, email: 'chenjinxin@msjyamc.com.cn', password: '12345678',usertype: 'staff')
	zyj=User.create(username: :张亚军, email: 'zhangyajun@msjyamc.com.cn', password: '12345678',usertype: 'staff')
	spj=User.create(username: :舍蒲京, email: 'shepujing@msjyamc.com.cn', password: '12345678',usertype: 'staff')
	mgq=User.create(username: :马国庆, email: 'maguoqing@msjyamc.com.cn', password: '12345678', usertype: 'admin')
	DepartmentUser.create(department: hlw, user: mgq, role: 'admin')
	DepartmentUser.create(department: hlw, user: cjx)
	DepartmentUser.create(department: hlw, user: zyj) 
	DepartmentUser.create(department: hlw, user: spj)

	expect(mgq.email).to eq('maguoqing@msjyamc.com.cn')
	expect(mgq.username).to eq('马国庆')
	task2=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 120000, taskable: mgq)
	task3=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 160000, taskable: mgq)
	task4=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 120000, taskable: mgq)
	task5=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: mgq)
	task6=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 300000, taskable: mgq)
	task7=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[2], amount: 200000, taskable: mgq)

	expect(mgq.count_tasks(Task::TASK_TYPE[0])).to eq(400000)
	expect(mgq.count_scale_tasks).to eq(400000)
	expect(mgq.count_management_fee_tasks).to eq(500000)
	expect(mgq.count_fee_tasks).to eq(200000)
	expect(mgq.count_all_type_task).to eq([400000,500000,200000])

	#计划  项目   项目调整
	plan1=Plan.create(name: '汇赢1号', plan_type: Plan::PLAN_TYPE[1],number: 10000001, user: mgq, department: jh, parter: :民生银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004)
	plan2=Plan.create(name: '保腾1号', plan_type: Plan::PLAN_TYPE[1], number: 10000002, user: mgq, department: jh, parter: :民生银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004)
	plan3=Plan.create(name: '民生加银资管永昌地产集团专项资产管理计划', plan_type: Plan::PLAN_TYPE[0], number: :WDC15015, user: mgq, department: jh,parter: :民生银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004)

	project1=Project.create(name: '苏州高铁新城经济发展有限公司', number: :QS713003, plan: plan1, user: mgq, department: jh,parter: :民生银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.0774, pool_price: 0.077)
	project2=Project.create(name: '贵阳金阳建设投资（集团）有限公司', number: :WDC140AI, plan: plan1, user: mgq, department: jh, parter: :民生银行,  start_date: '2014-2-4', end_date: '2017-9-4',scale: 100000000, rate: 0.004, asset_price: 0.1, pool_price: 0.085)
	project3=Project.create(name: '龙岩汇通置业有限公司', number: :WDC1504Z, plan: plan1, user: mgq, department: jh, parter: :民生银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.1, pool_price: 0.081)

	project21=Project.create(name: '民生加银资管重庆溉澜溪专项资产管理计划', number: :QT9150KL,  plan: plan2, user: mgq, department: jh, parter: :民生银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.1, pool_price: 0.081)
	project22=Project.create(name: '民生加银资管创赢1号专项资产管理计划', number: :QT91514V,  plan: plan2, user: mgq, department: jh, parter: :建设银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.1, pool_price: 0.081)
	project23=Project.create(name: '民生加银资管创赢3号专项资产管理计划', number: :QT91514Z,  plan: plan2, user: mgq, department: jh, parter: :建设银行, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.1, pool_price: 0.081)


	pm1=Modification.create( project: project1,user: mgq, fee: 0.002, start_date: '2015-2-4', end_date: '2016-1-1',scale: 100000000, rate: 0.004)
	Modification.create( project: project1,user: mgq, fee: 0.002, start_date: '2016-1-1', end_date: '2017-1-1',scale: 100000000, rate: 0.004)
	Modification.create( project: project1,user: mgq, fee: 0.002, start_date: '2017-1-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004)

	puts mgq.count_fee_between(Date.new(Date.current.year,1,1), Date.new(Date.current.year+1,1,1))
	date=[Date.new(Date.current.year,1,1), Date.new(Date.current.year+1,1,1)]
	puts mgq.count_fee(date)
  end
end
