class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :plan, index: true, foreign_key: true  #资管计划
      t.references :user, index: true, foreign_key: true  
      t.string :number   #AM合同编号？ 好像没有
      t.string :name  #项目名称（资产名称）
      t.decimal :scale #当前规模
      
      t.decimal :asset_price  #投资段收益率
      
      t.date :start_date #放款日
      t.date :end_date   #到期日

      t.decimal :management_fee   #管理费   是计算出来？
      t.string :investment_manager  #投资经理   用user  不用这个字段？

      t.string :parter #合作机构

      t.references :department, index: true, foreign_key: true  
      t.decimal :rate   #费率
      t.decimal :fee    #费用金额 
      t.text :notes     #注释
      t.decimal :channel_cost #使用别的部分的资管计划的费用
      t.timestamps null: false
    end
  end
end