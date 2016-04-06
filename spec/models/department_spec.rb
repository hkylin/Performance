require 'rails_helper'

RSpec.describe Department, type: :model do
  it "should create a Department" do
	#--date--
  mj=Department.create(name: '民生加银资产管理有限公司')
  yg=Department.create(name: '业务管理部', sup_department: mj)
  hlw=Department.create(name: '互联网金融部', sup_department: yg)
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

  task2=Task.create(name: 'cjx月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 220000, taskable: cjx)
  task3=Task.create(name: 'cjx月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 160000, taskable: cjx)
  task4=Task.create(name: 'cjx月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 120000, taskable: cjx)
  task5=Task.create(name: 'cjx月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 100000, taskable: cjx)
  task6=Task.create(name: 'cjx月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 300000, taskable: cjx)
  task7=Task.create(name: 'cjx月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[2], amount: 100000, taskable: cjx)

  task2=Task.create(name: 'spj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 120000, taskable: spj)
  task3=Task.create(name: 'spj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 260000, taskable: spj)
  task4=Task.create(name: 'spj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 220000, taskable: spj)
  task5=Task.create(name: 'spj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: spj)
  task6=Task.create(name: 'spj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 300000, taskable: spj)
  task7=Task.create(name: 'spj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[2], amount: 200000, taskable: spj)

  task2=Task.create(name: 'zyj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 120000, taskable: zyj)
  task3=Task.create(name: 'zyj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 160000, taskable: zyj)
  task4=Task.create(name: 'zyj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[0], amount: 120000, taskable: zyj)
  task5=Task.create(name: 'zyj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 200000, taskable: zyj)
  task6=Task.create(name: 'zyj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[1], amount: 300000, taskable: zyj)
  task7=Task.create(name: 'zyj月月增利', start_date: '2016-1-1', end_date: '2017-1-1', task_type: Task::TASK_TYPE[2], amount: 200000, taskable: zyj)

  expect(mgq.count_tasks(Task::TASK_TYPE[0])).to eq(400000)
  expect(mgq.count_scale_tasks).to eq(400000)
  expect(mgq.count_management_fee_tasks).to eq(500000)
  expect(mgq.count_fee_tasks).to eq(200000)
  end
end
