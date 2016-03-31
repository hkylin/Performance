# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)



mj=Department.create(name: '民生加银资产管理有限公司')
cf=Department.create(name: '财富管理事业部', sup_department: mj)
jh=Department.create(name: '金融合作事业部', sup_department: mj)
qj=Department.create(name: '企业金融事业部', sup_department: mj)
# hb=Department.create(name: '华北区域总部', sup_department: mj)
# hd=Department.create(name: '华东区域总部', sup_department: mj)
# Department.create(name: '华南区域总部', sup_department: mj)
# Department.create(name: '西部区域总部', sup_department: mj)

# Department.create(name: '资产证券化小组', sup_department: qj)
# Department.create(name: '基础设施小组', sup_department: qj)
# Department.create(name: '投资银行小组', sup_department: qj)
# Department.create(name: '新兴产业小组', sup_department: qj)
# Department.create(name: '民加资本投资公司', sup_department: qj)
Department.create(name: '资本市场小组', sup_department: qj)
Department.create(name: '综合管理部', sup_department: qj)
yg=Department.create(name: '业务管理部', sup_department: mj)

hlw=Department.create(name: '互联网金融部', sup_department: cf)
jg=Department.create(name: '机构客户中心', sup_department: cf)
gr=Department.create(name: '个人客户中心', sup_department: cf)
cpyf=Department.create(name: '产品研发中心', sup_department: cf)

mhj=User.create(email: 'mahuijun@msjyamc.com.cn', password: '12345678',username: '马慧军', usertype: 'admin')
jgr=User.create(email: 'jinguorui@msjyamc.com.cn', password: '12345678', username: '金国瑞', usertype: 'admin')

mgq=User.create(username: :马国庆, email: 'maguoqing@msjyamc.com.cn', password: '12345678', usertype: 'admin')

cjx=User.create(username: :陈金鑫, email: 'chenjinxin@msjyamc.com.cn', password: '12345678',usertype: 'staff')
zyj=User.create(username: :张亚军, email: 'zhangyajun@msjyamc.com.cn', password: '12345678',usertype: 'staff')
spj=User.create(username: :舍蒲京, email: 'shepujing@msjyamc.com.cn', password: '12345678',usertype: 'staff')
# users=[mhj,jgr]
# cf.users=users
# cf.save

#----财富事业部领导配置

DepartmentUser.create(department: cf, user: mhj, role: 'admin')
DepartmentUser.create(department: cf, user: jgr, role: 'admin')
# DepartmentUser.create(department: jg, user: jgr, role: 'have')
# DepartmentUser.create(department: jg, user: mhj, role: 'have')
# DepartmentUser.create(department: gr, user: jgr, role: 'have')
# DepartmentUser.create(department: gr, user: mhj, role: 'have')
# DepartmentUser.create(department: cpyf, user: jgr, role: 'have')
# DepartmentUser.create(department: cpyf, user: mhj, role: 'have')
# cf.save

#DepartmentUser.create(department: hlw, user: jgr, role: 'have')#have代表管理,直属子部门不再需要，只有跨事业部，跨条线的时候才需要
#DepartmentUser.create(department: hlw, user: mhj, role: 'have')

#----互联网金融部配置
DepartmentUser.create(department: hlw, user: mgq, role: 'admin')

DepartmentUser.create(department: hlw, user: cjx)
DepartmentUser.create(department: hlw, user: zyj)
DepartmentUser.create(department: hlw, user: spj)
# hlw.save

Task.create(name: '互联网金融部考核指标——月月增利', start_date: '2016-1-1', end_date: '2017-1-1',  task_type: Task::TASK_TYPE[1], amount: 120000, taskable: hlw)
task1=Task.create(name: '月月增利', task_type: Task::TASK_TYPE[0], start_date: '2016-1-1', end_date: '2017-1-1', amount: 120000)
task1.taskable=cf
task1.save
task2=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1',  task_type: Task::TASK_TYPE[0], amount: 120000, taskable: mgq)
task3=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 160000, taskable: mgq)
task3=Task.create(name: 'magq月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: mgq)
task4=Task.create(name: '马总 月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 240000, taskable: mhj)
task5=Task.create(name: '金总 月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 240000, taskable: jgr)
task6=Task.create(name: '财富事业部 月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: cf)

task7=Task.create(name: '个人客户中心 月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 40000, taskable: gr)
task8=Task.create(name: '机构客户中心 月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: jg)
task8=Task.create(name: '产品研发中心 个人产品', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: cpyf)

task11=Task.create(name: '陈金鑫 月月增利', start_date: '2016-1-1', end_date: '2017-1-1',  task_type: Task::TASK_TYPE[1], amount: 120000, taskable: cjx)
task12=Task.create(name: '蒲京 月月增利',   start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 160000, taskable: spj)
task13=Task.create(name: '张亚军 月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: zyj)

#计划  项目   项目调整
plan1=Plan.create(name: '汇赢1号', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0], number: 10000001, user: mgq, department: jh, parter: :民生银行, risk: :正常, start_date: '2015-1-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
plan2=Plan.create(name: '保腾1号', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0],  number: 10000002, user: mgq, department: jh, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-6-4',scale: 100000000, rate: 0.004, annual: 365)
plan3=Plan.create(name: '民生加银资管永昌地产集团专项资产管理计划',plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0],  number: :WDC15015, user: mgq, department: jh,parter: :民生银行, risk: :正常, start_date: '2014-1-4', end_date: '2018-2-4',scale: 100000000, rate: 0.004, annual: 365)

plan4=Plan.create(name: '全权委托1', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0],number: 10000011, user: mhj, department: cf, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 600000000, rate: 0.004, annual: 365)
plan5=Plan.create(name: '全权委托2', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0],number: 10000012, user: jgr, department: cf, parter: :民生银行, risk: :正常,  start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
plan6=Plan.create(name: '全权委托3', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0],number: 10000013, user: jgr, department: cf, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)


Plan.create(name: '全权委托-普通收费1', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0],number: 10000021, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2016-2-28',scale: 100000000, rate: 0.004, annual: 365)
Plan.create(name: '全权委托-前收费1', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[1], charge_amount:10000, number: 10000022, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2016-2-28',scale: 100000000, rate: 0.004, annual: 365)
Plan.create(name: '全权委托-后收费1', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[2], charge_amount:10000, number: 10000023, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2016-2-28',scale: 100000000, rate: 0.004, annual: 365)

Plan.create(name: '全权委托-普通收费2', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0], number: 10000031, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-1-1', end_date: '2016-6-1',scale: 100000000, rate: 0.004, annual: 365)
Plan.create(name: '全权委托-前收费2', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[1], charge_amount:10000, number: 10000032, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-1-1', end_date: '2016-6-1',scale: 100000000, rate: 0.004, annual: 365)
Plan.create(name: '全权委托-后收费2', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[2], charge_amount:10000, number: 10000033, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-1-1', end_date: '2016-6-1',scale: 100000000, rate: 0.004, annual: 365)

Plan.create(name: '全权委托-普通收费3', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0],number: 10000041, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
Plan.create(name: '全权委托-前收费3', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[1], charge_amount:10000, number: 10000042, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
Plan.create(name: '全权委托-后收费3', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[2], charge_amount:10000, number: 10000043, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)


plan7=Plan.create(name: '全权委托-普通收费4-有修改', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0],number: 10000051, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
plan8=Plan.create(name: '全权委托-前收费4', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[1], charge_amount:10000, number: 10000052, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
plan9=Plan.create(name: '全权委托-后收费4', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[2], charge_amount:10000, number: 10000053, user: mgq, department: cf, parter: :民生银行, risk: :正常, start_date: '2016-2-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
Modification.create( modificationable: plan7, user: mgq, charge_type: Plan::CHARGE_TYPE[1], charge_amount: 10000, risk: :正常, start_date: '2016-2-1', end_date: '2016-10-4',scale: 100000000, rate: 0.004, annual: 365)
Modification.create( modificationable: plan7, user: mgq, charge_type: Plan::CHARGE_TYPE[0], risk: :正常, start_date: '2016-10-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)

Cooperation.create(user: mgq, ratio: 0.3, cooperationable: plan1)
Cooperation.create(user: zyj, ratio: 0.4, cooperationable: plan1)
Cooperation.create(user: spj, ratio: 0.3, cooperationable: plan1)


project1=Project.create(name: '苏州高铁新城经济发展有限公司', number: :QS713003, plan: plan1, user: mgq, department: jh,parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.0774, annual: 365)
project2=Project.create(name: '贵阳金阳建设投资（集团）有限公司', number: :WDC140AI, plan: plan1, user: mgq, department: jh, parter: :民生银行, risk: :正常,  start_date: '2014-2-4', end_date: '2017-9-4',scale: 100000000, rate: 0.004, asset_price: 0.1, annual: 365)
project3=Project.create(name: '龙岩汇通置业有限公司', number: :WDC1504Z, plan: plan1, user: mgq, department: jh, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.1, annual: 365)

project21=Project.create(name: '民生加银资管重庆溉澜溪专项资产管理计划', number: :QT9150KL,  plan: plan2, user: mgq, department: jh, parter: :民生银行, risk: :正常, start_date: '2015-1-6', end_date: '2017-6-6',scale: 100000000, rate: 0.004, asset_price: 0.1, annual: 365)
project22=Project.create(name: '民生加银资管创赢1号专项资产管理计划', number: :QT91514V,  plan: plan2, user: mgq, department: jh, parter: :建设银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-3-4',scale: 100000000, rate: 0.004, asset_price: 0.1, annual: 365)
project23=Project.create(name: '民生加银资管创赢3号专项资产管理计划', number: :QT91514Z,  plan: plan2, user: mgq, department: jh, parter: :建设银行, risk: :正常, start_date: '2016-1-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, asset_price: 0.1, annual: 365)


Cooperation.create(user: mgq, ratio: 0.3, cooperationable: project1)
Cooperation.create(user: zyj, ratio: 0.4, cooperationable: project1)
Cooperation.create(user: spj, ratio: 0.3, cooperationable: project1)

pm1=Modification.create( modificationable: project1,user: mgq, fee: 0.002, risk: :正常, start_date: '2015-2-4', end_date: '2016-1-1',scale: 100000000, rate: 0.004)
Modification.create( modificationable: project1,user: mgq, fee: 0.002, risk: :正常, start_date: '2016-1-1', end_date: '2017-1-1',scale: 100000000, rate: 0.004)
Modification.create( modificationable: project1,user: mgq, fee: 0.002, risk: :正常, start_date: '2017-1-1', end_date: '2017-2-4',scale: 100000000, rate: 0.004)

plan14=Plan.create(name: '4', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0],number: 100000014, user: zyj, department: hlw,risk: :正常,  start_date: '2016-1-1', end_date: '2017-1-1', scale: 100000000, rate: 0.004)
project31=Project.create(name: 'project31', plan: plan14, user: zyj, department: hlw, risk: :正常,  start_date: '2016-1-1', end_date: '2017-1-1',scale: 100000000, rate: 0.004, asset_price: 0.1)
project32=Project.create(name: 'project32', plan: plan14, user: zyj, department: hlw, risk: :正常, start_date: '2016-1-1', end_date: '2017-1-1',scale: 100000000, rate: 0.004, asset_price: 0.1)
Modification.create( modificationable: project31,user: zyj, risk: :正常,  start_date: '2016-1-1', end_date: '2017-1-1',scale: 100000000, rate: 0.004, fee: 0.002)
Modification.create( modificationable: project31,user: zyj, risk: :正常,  start_date: '2016-1-1', end_date: '2017-1-1',scale: 100000000, rate: 0.004, fee: 0.002)
Modification.create( modificationable: project31,user: zyj, risk: :正常, start_date: '2016-1-1', end_date: '2017-1-1',scale: 100000000, rate: 0.004, fee: 0.002)

Cooperation.create(user: mgq, ratio: 0.3, cooperationable: pm1)
Cooperation.create(user: zyj, ratio: 0.4, cooperationable: pm1)
Cooperation.create(user: spj, ratio: 0.3, cooperationable: pm1)

# ----Person结构化数据构造----
# father=Person.create(name: 'mayuhai')

# mgq=Person.create(name: 'maguoqing')
# mxl=Person.create(name: 'maxiuling')
# mxy=Person.create(name: 'maxiuyan')

# yc=Person.create(name: 'yangchen')
# zyw=Person.create(name: 'zhangyiwen')
# lfy=Person.create(name: 'lifangy')

# father.sons<<mgq
# father.sons<<mxl
# father.sons<<mxy
# father.save

# mxl.sons<<lfy
# mxl.save

# mxy.sons<<yc
# mxy.sons<<zyw
# mxy.save
