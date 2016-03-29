class DepartmentsController < ApplicationController
	before_action :authenticate_user!
	def index
		@departments=current_user.departments
		@users=Array.new
		@departments.each do |x|
			x.users.each do |user|
				@users<<user
			end
		end
		
		@users.each do |x|
			puts x
		end
		@users

	# y1=current_user.count_fee Date.one_year
 #    q1=current_user.count_fee Date.first_quarter    
 #    q2=current_user.count_fee Date.second_quarter   
 #    q3=current_user.count_fee Date.third_quarter 
 #    q4=current_user.count_fee Date.fourth_quarter 
 #    count_fees=[y1.to_i,q1.to_i,q2.to_i,q3.to_i,q4.to_i]
 #    count_fees = current_user.quarters
 #    t1=current_user.count_management_fee_tasks.to_i
 #    t14=(current_user.count_management_fee_tasks.to_i/4).to_i
 #    tasks=[t1,t14,t14,t14,t14]

 #    @chart = LazyHighCharts::HighChart.new('graph') do |f|
 #      f.title(text: "指标与完成情况")
 #      f.xAxis(categories: ["全年","一季度", "二季度", "三季度", "四季度"])
 #      f.series(name: "完成情况", yAxis: 0, data: count_fees)
 #      f.series(name: "指标", yAxis: 1, data: tasks)

 #      f.yAxis [
 #        {title: {text: "指标", margin: 70} },
 #        {title: {text: "完成情况"}, opposite: true},
 #      ]

 #      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
 #      f.chart({defaultSeriesType: "column"})
 #    end

 #    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
 #      f.global(useUTC: false)
 #      f.chart(
 #        backgroundColor: {
 #          linearGradient: [0, 0, 500, 500],
 #          stops: [
 #            [0, "rgb(255, 255, 255)"],
 #            [1, "rgb(240, 240, 255)"]
 #          ]
 #        },
 #        borderWidth: 2,
 #        plotBackgroundColor: "rgba(255, 255, 255, .9)",
 #        plotShadow: true,
 #        plotBorderWidth: 1
 #      )
 #      f.lang(thousandsSep: ",")
 #      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
 #    end
 
	end
end
