class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :number #AM合同代码
      t.string :name   #计划名称
      t.string :plan_type  #集合|单一
      t.decimal :scale #当前规模
      t.date :start_date #成立日期
      t.date :end_date   #到期日
      t.decimal :management_fee #管理费
      t.string :investment_manager  #投资经理
      t.references :department, index: true, foreign_key: true #部门
      t.decimal :rate   #费率
      t.decimal :fee    #费用金额
      t.references :user, index: true, foreign_key: true  #投资经理
      t.string :parter #合作伙伴
      t.text :notes

      t.timestamps null: false
    end
  end
end

#删除无效item
#this_amount
#year_amount
#a_class
#b_class

#修改number  由integer  修改成string

#以下内容与绩效考核是否相关?
#费用支付频率
#收益分配频率
#收益率
