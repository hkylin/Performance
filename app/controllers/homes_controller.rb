class HomesController < ApplicationController
  # before_action :set_plan, only: [:department, :user]
  before_action :authenticate_user!

  def index
    @plans = current_user.plans
    @projects = current_user.projects
    @tasks = current_user.tasks


    y1=current_user.count_fee Date.one_year
    q1=current_user.count_fee Date.first_quarter    
    q2=current_user.count_fee Date.second_quarter   
    q3=current_user.count_fee Date.third_quarter 
    q4=current_user.count_fee Date.fourth_quarter 

    count_fees=[y1.to_i,q1.to_i,q2.to_i,q3.to_i,q4.to_i]
    t1=current_user.count_management_fee_tasks.to_i
    t14=(current_user.count_management_fee_tasks.to_i/4).to_i
    tasks=[t1,t14,t14,t14,t14]
    logger.info '==============-------------------=================='
    logger.info y1
    logger.info current_user.count_fee Date.one_year
    logger.info current_user.count_management_fee_tasks 
    logger.info count_fees[0].class
    logger.info count_fees[0]
    logger.info  tasks

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "指标与完成情况")
      f.xAxis(categories: ["全年","一季度", "二季度", "三季度", "四季度"])
      f.series(name: "完成情况", yAxis: 0, data: count_fees)
      f.series(name: "指标", yAxis: 1, data: tasks)

      f.yAxis [
        {title: {text: "指标", margin: 70} },
        {title: {text: "完成情况"}, opposite: true},
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75000, x: 500000, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
    end

    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },
        borderWidth: 2,
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
    end

  end

  def department
  	@department=Department.find (params[:department_id])  #解决传递参数问题
    admin_departments=current_user.admin_departments 

    if ( admin_departments.size > 0 )
      ids=admin_departments.collect{|x| x.id}
      logger.debug("----------#{ids}----------")
      if(ids.include?(params[:department_id].to_i))
        return
      else
        redirect_to homes_index_path, notice: '越权访问' 
      end
    end
  end

  def user
    @user = User.find(params[:user_id])
  	# @user=User.find_by_email('zhangyajun@msjyamc.com.cn')
  end

  def between
    
  end

  def at_date

  end

  def scale
    logger.info  params[:at_date]  
  end



  def statistics
    logger.info  params[:start_date]
    logger.info  params[:end_date]
  end


  def between2
    @plan = Plan.new
    logger.info  params[:start_date]
    logger.info  params[:end_date]
  end

  def between3
    @plan = Plan.new
    logger.info  params[:start_date]
    logger.info  params[:end_date]
  end

protected
  # # Use callbacks to share common setup or constraints between actions.
  #   def set_plan
  #     @plan = Plan.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def plan_params
  #     params.require(:plan).permit(:department_id, :user_id)
  #   end

#TODO   应该是不针对类型的。
  def plan_params
      params.require(:plan).permit(:number, :name, :this_amount, :year_amount, :start_date, :end_date, :management_fee, :investment_manager, :scale, :department_id, :rate, :fee, :notes, :plan_type, :annual, :risk, :parter)
      params.permit(:start_date, :end_date)
    end
end
