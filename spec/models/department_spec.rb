require 'rails_helper'

RSpec.describe Department, type: :model do
  it "should create a Department" do
    mj=Department.create(name: '民生加银资产管理有限公司')
    yg=Department.create(name: '业务管理部', sup_department: mj)
    cjx=User.create(username: :陈金鑫, email: 'chenjinxin@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    zyj=User.create(username: :张亚军, email: 'zhangyajun@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    spj=User.create(username: :舍蒲京, email: 'shepujing@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    mgq=User.create(username: :马国庆, email: 'maguoqing@msjyamc.com.cn', password: '12345678', usertype: 'admin')

    expect(mgq.email).to eq('maguoqing@msjyamc.com.cn')
    expect(mgq.username).to eq('马国庆')
    task2=Task.create(year: 2016,amount: 2000000000,profit: 120000, taskable: mgq)
    task2=Task.create(year: 2016,amount: 2000000000,profit: 120000, taskable: zyj)
    task2=Task.create(year: 2016,amount: 2000000000,profit: 120000, taskable: spj)
    task2=Task.create(year: 2016,amount: 2000000000,profit: 120000, taskable: cjx)
    
    expect(mgq.count_scale_tasks).to eq(2000000000)
    expect(mgq.count_management_fee_tasks).to eq(120000)

  end  

  it "should test count" do 
    #计划  项目   项目调整


    mj=Department.create(name: '民生加银资产管理有限公司')
    
    yg=Department.create(name: '业务管理部', sup_department: mj)
    hlw=Department.create(name: '互联网金融部', sup_department: yg)

    jh=Department.create(name: '金融合作事业部', sup_department: mj)
    jh1=Department.create(name: '金融合作一部', sup_department: jh)
    jh2=Department.create(name: '金融合作二部', sup_department: jh)
    jh3=Department.create(name: '金融合作三部', sup_department: jh)
    hzzc=Department.create(name: '金融合作三部', sup_department: jh)

    cjx=User.create(username: :陈金鑫, email: 'chenjinxin@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    zyj=User.create(username: :张亚军, email: 'zhangyajun@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    spj=User.create(username: :舍蒲京, email: 'shepujing@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    mgq=User.create(username: :马国庆, email: 'maguoqing@msjyamc.com.cn', password: '12345678', usertype: 'admin')
    DepartmentUser.create(department: hlw, user: mgq, role: 'admin')
    DepartmentUser.create(department: hlw, user: cjx, role: 'staff')
    DepartmentUser.create(department: hlw, user: zyj, role: 'staff') 
    DepartmentUser.create(department: hlw, user: spj, role: 'staff')
   
    wangjinfeng =User.create(username: :王金凤 ,email: 'wangjinfeng@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    shiweisi =User.create(username: :史维思 ,email: 'shiweisi@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    qiuli =User.create(username: :邱莉 ,email: 'qiuli@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    chenfan =User.create(username: :陈凡 ,email: 'chenfan@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    luozichen =User.create(username: :罗自琛 ,email: 'luozichen@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    huangjian =User.create(username: :黄健 ,email: 'huangjian@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    teriwen =User.create(username: :特日文 ,email: 'teriwen@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    DepartmentUser.create(department: jh1, user: wangjinfeng, role: 'admin')
    DepartmentUser.create(department: jh1, user: shiweisi, role: 'staff')
    DepartmentUser.create(department: jh1, user: qiuli, role: 'staff')
    DepartmentUser.create(department: jh1, user: chenfan, role: 'staff')
    DepartmentUser.create(department: jh1, user: luozichen, role: 'staff')
    DepartmentUser.create(department: jh1, user: huangjian, role: 'staff')
    DepartmentUser.create(department: jh1, user: teriwen, role: 'staff')

    yuyong =User.create(username: :于勇 ,email: 'yuyong@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    libin =User.create(username: :李彬 ,email: 'libin@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    houzhen =User.create(username: :侯震 ,email: 'houzhen@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    liuyanze =User.create(username: :刘彦泽 ,email: 'liuyanze@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    kongyilong =User.create(username: :孔一龙 ,email: 'kongyilong@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    DepartmentUser.create(department: jh2, user: yuyong, role: 'admin')
    DepartmentUser.create(department: jh2, user: libin, role: 'staff')
    DepartmentUser.create(department: jh2, user: houzhen, role: 'staff')
    DepartmentUser.create(department: jh2, user: liuyanze, role: 'staff')
    DepartmentUser.create(department: jh2, user: kongyilong, role: 'staff')

    songlin =User.create(username: :宋琳 ,email: 'songlin@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    wangtao =User.create(username: :王涛 ,email: 'wangtao@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    liwei =User.create(username: :李炜 ,email: 'liwei@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    daigang =User.create(username: :戴刚 ,email: 'daigang@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    wangyue =User.create(username: :王越 ,email: 'wangyue@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    DepartmentUser.create(department: jh3, user: songlin, role: 'admin')
    DepartmentUser.create(department: jh3, user: wangtao, role: 'staff')
    DepartmentUser.create(department: jh3, user: liwei, role: 'staff')
    DepartmentUser.create(department: jh3, user: daigang, role: 'staff')
    DepartmentUser.create(department: jh3, user: wangyue, role: 'staff')

    liangfeng =User.create(username: :梁奉 ,email: 'liangfeng@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    huxinyang =User.create(username: :胡新阳 ,email: 'huxinyang@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    DepartmentUser.create(department: hzzc, user: liangfeng, role: 'admin')
    DepartmentUser.create(department: hzzc, user: huxinyang, role: 'staff')

    plan1=Plan.create(name: 'hlw部门计划1', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0], ownership_type: Plan::OWNERSHIP_TYPE[0], number: 10000001, user: huxinyang, department: hlw, parter: :民生银行, risk: :正常, start_date: '2015-1-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
    plan2=Plan.create(name: 'hlw部门计划2', plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0], ownership_type: Plan::OWNERSHIP_TYPE[0], number: 10000002, user: huxinyang, department: hlw, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-6-4',scale: 100000000, rate: 0.004, annual: 365)
    plan3=Plan.create(name: '一部门计划1',plan_type: Plan::PLAN_TYPE[1], charge_type: Plan::CHARGE_TYPE[0], ownership_type: Plan::OWNERSHIP_TYPE[0], number: :WDC15015, user: huxinyang, department: jh1,parter: :民生银行, risk: :正常, start_date: '2014-1-4', end_date: '2018-2-4',scale: 100000000, rate: 0.004, annual: 365)
    plan4=Plan.create(name: '一部门计划2', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0], ownership_type: Plan::OWNERSHIP_TYPE[0], number: 10000011, user: huxinyang, department: jh1, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 600000000, rate: 0.004, annual: 365)
    plan5=Plan.create(name: '二部门计划1', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0], ownership_type: Plan::OWNERSHIP_TYPE[0], number: 10000012, user: huxinyang, department: jh2, parter: :民生银行, risk: :正常,  start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)
    plan6=Plan.create(name: '三部门计划1', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[0], ownership_type: Plan::OWNERSHIP_TYPE[0], number: 10000013, user: huxinyang, department: jh3, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, rate: 0.004, annual: 365)

    project1=Project.create(name: 'hlw all inuser', number: :QS713003, plan: plan1, user: mgq, department: hlw,parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, channel_cost: 0.0, rate: 0.004, asset_price: 0.0774, annual: 365)
    project2=Project.create(name: 'hlw outuser shiweisi', number: :WDC140AI, plan: plan1, user: mgq, department: hlw, parter: :民生银行, risk: :正常,  start_date: '2014-2-4', end_date: '2017-9-4',scale: 100000000, channel_cost: 0.0, rate: 0.004, asset_price: 0.1, annual: 365)
    project3=Project.create(name: 'hlw only mgq', number: :WDC1504Z, plan: plan1, user: mgq, department: hlw, parter: :民生银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-2-4',scale: 100000000, channel_cost: 0.0, rate: 0.004, asset_price: 0.1, annual: 365)

    project21=Project.create(name: '一部项目1', number: :QT9150KL,  plan: plan3, user: mgq, department: jh1, parter: :民生银行, risk: :正常, start_date: '2015-1-6', end_date: '2017-6-6',scale: 100000000, channel_cost: 0.0,  rate: 0.004, asset_price: 0.1, annual: 365)
    project22=Project.create(name: '一部项目2', number: :QT91514V,  plan: plan3, user: mgq, department: jh1, parter: :建设银行, risk: :正常, start_date: '2015-2-4', end_date: '2017-3-4',scale: 100000000, channel_cost: 0.0, rate: 0.004, asset_price: 0.1, annual: 365)
    project23=Project.create(name: '一部项目3', number: :QT91514Z,  plan: plan4, user: mgq, department: jh2, parter: :建设银行, risk: :正常, start_date: '2016-6-4', end_date: '2017-2-4',scale: 100000000, channel_cost: 0.0, rate: 0.004, asset_price: 0.1, annual: 365)
    
    project23=Project.create(name: '二部项目2', number: :QT91514Z,  plan: plan5, user: mgq, department: jh2, parter: :建设银行, risk: :正常, start_date: '2016-6-4', end_date: '2017-2-4',scale: 100000000, channel_cost: 0.0, rate: 0.004, asset_price: 0.1, annual: 365)
    project23=Project.create(name: '三部项目3', number: :QT91514Z,  plan: plan6, user: mgq, department: jh2, parter: :建设银行, risk: :正常, start_date: '2016-6-4', end_date: '2017-2-4',scale: 100000000, channel_cost: 0.0, rate: 0.004, asset_price: 0.1, annual: 365)

    Cooperation.create(user: mgq, ratio: 0.3, cooperationable: project1, co_type: Cooperation::CO_TYPE[0])
    Cooperation.create(user: zyj, ratio: 0.4, cooperationable: project1, co_type: Cooperation::CO_TYPE[1])
    Cooperation.create(user: spj, ratio: 0.3, cooperationable: project1, co_type: Cooperation::CO_TYPE[1])

    Cooperation.create(user: mgq, ratio: 0.7, cooperationable: project2, co_type: Cooperation::CO_TYPE[1])
    Cooperation.create(user: mgq, ratio: 0.3, cooperationable: project2, co_type: Cooperation::CO_TYPE[1])

    Cooperation.create(user: mgq, ratio: 1.0, cooperationable: project3, co_type: Cooperation::CO_TYPE[1])

    Cooperation.create(user: mgq, ratio: 1.0, cooperationable: project21, co_type: Cooperation::CO_TYPE[1])
    Cooperation.create(user: mgq, ratio: 1.0, cooperationable: project22, co_type: Cooperation::CO_TYPE[1])
    Cooperation.create(user: mgq, ratio: 1.0, cooperationable: project23, co_type: Cooperation::CO_TYPE[1])
    puts hlw.count_scale2
    puts hlw.count_income2
    puts jh1.count_scale2
    puts jh1.count_income2
    puts jh2.count_scale2
    puts jh2.count_income2
    puts jh3.count_scale2
    puts jh3.count_income2
    puts jh.count_scale2
    puts jh.count_income2
  end


  it 'should test count_scale2' do
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

    Department.create(name: '资本市场小组', sup_department: qj)
    Department.create(name: '综合管理部', sup_department: qj)
    yg=Department.create(name: '业务管理部', sup_department: mj)

    hlw=Department.create(name: '互联网金融部', sup_department: cf)
    jg=Department.create(name: '机构客户中心', sup_department: cf)
    gr=Department.create(name: '个人客户中心', sup_department: cf)
    cpyf=Department.create(name: '产品研发中心', sup_department: cf)

    hzzc=Department.create(name: '合作支持部', sup_department: jh)
    jh1=Department.create(name: '金融合作一部', sup_department: jh)
    jh2=Department.create(name: '金融合作二部', sup_department: jh)
    jh3=Department.create(name: '金融合作三部', sup_department: jh)
    jh4=Department.create(name: '金融合作四部', sup_department: jh)
    jh5=Department.create(name: '金融合作五部', sup_department: jh)
    jhcx1=Department.create(name: '创新业务一部', sup_department: jh)
    jhcx2=Department.create(name: '创新业务二部', sup_department: jh)

    czh=User.create(email: 'chenzhihua@msjyamc.com.cn', password: '12345678', username: '陈志华', usertype: 'admin')
    lf=User.create(username: :梁奉, email: 'liangfeng@msjyamc.com.cn', password: '12345678',usertype: 'admin')
    zyl=User.create(username: :朱永林, email: 'zhuyonglin@msjyamc.com.cn', password: '12345678',usertype: 'staff')

    wjf=User.create(username: :王金凤, email: 'wangjinfeng@msjyamc.com.cn', password: '12345678',usertype: 'admin')
    sws=User.create(username: :史维思, email: 'shiweisi@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    hj=User.create(username: :黄健, email: 'huangjian@msjyamc.com.cn', password: '12345678',usertype: 'staff')

    usl=User.create(username: :宋琳, email: 'songlin@msjyamc.com.cn', password: '12345678',usertype: 'admin')
    uwt=User.create(username: :王涛, email: 'wangtao@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    ulw=User.create(username: :李炜, email: 'liwei@msjyamc.com.cn', password: '12345678',usertype: 'staff')

    DepartmentUser.create(department: hzzc, user: lf, role: 'admin')
    DepartmentUser.create(department: hzzc, user: zyl, role: 'staff')

    DepartmentUser.create(department: jh1, user: wjf, role: 'admin')
    DepartmentUser.create(department: jh1, user: sws, role: 'staff')
    DepartmentUser.create(department: jh1, user: hj, role: 'staff')

    DepartmentUser.create(department: jh3, user: usl, role: 'admin')
    DepartmentUser.create(department: jh3, user: uwt, role: 'staff')
    DepartmentUser.create(department: jh3, user: ulw, role: 'staff')

    mhj=User.create(email: 'mahuijun@msjyamc.com.cn', password: '12345678',username: '马慧军', usertype: 'admin')
    jgr=User.create(email: 'jinguorui@msjyamc.com.cn', password: '12345678', username: '金国瑞', usertype: 'admin')
    mgq=User.create(username: :马国庆, email: 'maguoqing@msjyamc.com.cn', password: '12345678', usertype: 'admin')
    cjx=User.create(username: :陈金鑫, email: 'chenjinxin@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    zyj=User.create(username: :张亚军, email: 'zhangyajun@msjyamc.com.cn', password: '12345678',usertype: 'staff')
    spj=User.create(username: :舍蒲京, email: 'shepujing@msjyamc.com.cn', password: '12345678',usertype: 'staff')

    DepartmentUser.create(department: cf, user: mhj, role: 'admin')
    DepartmentUser.create(department: cf, user: jgr, role: 'admin')
    DepartmentUser.create(department: jh, user: czh, role: 'admin')
    DepartmentUser.create(department: hlw, user: mgq, role: 'admin')
    DepartmentUser.create(department: hlw, user: cjx, role: 'staff')
    DepartmentUser.create(department: hlw, user: zyj, role: 'staff')
    DepartmentUser.create(department: hlw, user: spj, role: 'staff')

    task1=Task.create(year: 2016, profit: 20000000, amount: 12000000, taskable: cf)
    task2=Task.create(year: 2016, profit: 20000000, amount: 120000000, taskable: mgq)
    task4=Task.create(year: 2016, profit: 20000000, amount: 240000000, taskable: mhj)
    task5=Task.create(year: 2016, profit: 20000000, amount: 240000000, taskable: jgr)
    task6=Task.create(year: 2016, profit: 20000000, amount: 200000000, taskable: cf)
    task7=Task.create(year: 2016, profit: 20000000, amount: 40000000, taskable: gr)
    task8=Task.create(year: 2016, profit: 20000000, amount: 200000000, taskable: jg)
    task8=Task.create(year: 2016, profit: 20000000, amount: 200000000, taskable: cpyf)
    task11=Task.create(year: 2016, profit: 20000000, amount: 120000000, taskable: cjx)
    task12=Task.create(year: 2016, profit: 20000000, amount: 160000000, taskable: spj)
    task13=Task.create(year: 2016, profit: 20000000, amount: 200000000, taskable: zyj)
    plan1=Plan.create(name: '金和1号', plan_type: Plan::PLAN_TYPE[0], charge_type: Plan::CHARGE_TYPE[1], ownership_type: Plan::OWNERSHIP_TYPE[1],charge_amount:10000, charge_date:'2016-4-6', number: 10000032, user: lf, department: jh2, parter: :民生银行, risk: :正常, start_date: '2016-4-1', end_date: '2016-6-28',scale: 800000000, rate: 0.004, annual: 360)


    project1=Project.create(name: '苏州高铁新城经济发展有限公司1', number: :QS713003, plan: plan1, user: usl, department: jh2,parter: :民生银行, risk: :正常, start_date: '2016-4-1', end_date: '2016-6-28',scale: 800000000, channel_cost: 0.5, rate: 0.004, annual: 360)

    Cooperation.create(user: usl, ratio: 0.3, cooperationable: project1, co_type: Cooperation::CO_TYPE[0])
    Cooperation.create(user: wjf, ratio: 0.7, cooperationable: project1, co_type: Cooperation::CO_TYPE[1])
    # puts "-------jh1-------"
    # puts jh1.count_scale2
    # jh1.members.each do |m|
    #     puts m.name
    # end
    # puts jh1.count_inproject_outuser_scale(Date.current)
    # puts jh1.count_outproject_inuser_scale(Date.current)
    # puts jh1.count_income2
    puts "-------jh2-------"
    # puts jh2.count_scale2
    jh2.projects.cc.each do |p|
        puts p.name
    end
    puts jh2.count_inproject_outuser_scale(Date.current)
    # puts jh2.count_outproject_inuser_scale(Date.current)
    # puts jh2.count_income2
    # puts "-------jh3-------"
    # puts jh3.count_scale2
    # puts jh3.count_inproject_outuser_scale(Date.current)
    # puts jh3.count_outproject_inuser_scale(Date.current)
    # puts jh3.count_income2

  end
end
