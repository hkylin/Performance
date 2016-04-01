class HomesController < ApplicationController
  # before_action :set_plan, only: [:department, :user]
  before_action :authenticate_user!

  def index
    @plans = current_user.plans
    @projects = current_user.projects
    @tasks = current_user.tasks
    
    count_fees = current_user.quarters
    t1=current_user.count_management_fee_tasks.to_i
    t14=(current_user.count_management_fee_tasks.to_i/4).to_i
    st = current_user.count_scale_tasks.to_i
    # tasks=[t1,t14,t14,t14,t14,st,st]
    tasks=[t1,t14,t14,t14,t14]
    logger.info "--------------------------------------------"
    logger.info count_fees
    logger.info tasks
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "指标与完成情况")
      f.xAxis(categories: ["全年管理费","一季度管理费", "二季度管理费", "三季度管理费", "四季度管理费","当前规模","年化规模"])
      f.series(name: "完成情况", yAxis: 0, data: count_fees)
      f.series(name: "指标", yAxis: 1, data: tasks)

      f.yAxis [
        {title: {text: "指标", margin: 70} },
        {title: {text: "完成情况"}, opposite: true},
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
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
        plotBorderWidth: 1,
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
