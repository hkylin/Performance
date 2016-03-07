class HomesController < ApplicationController
  # before_action :set_plan, only: [:department, :user]
  before_action :authenticate_user!

  def index
    @plans = current_user.plans
    @projects = current_user.projects
    @tasks = current_user.tasks
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
protected
  # # Use callbacks to share common setup or constraints between actions.
  #   def set_plan
  #     @plan = Plan.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def plan_params
  #     params.require(:plan).permit(:department_id, :user_id)
  #   end
end
