class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # before_action :plan_manager?, only: [:show, :edit, :update, :destroy]


  def excel
    unless (current_user && (current_user.email=='liangfeng@msjyamc.com.cn')||(current_user.email=='zhuyonglin@msjyamc.com.cn'))
      redirect_to plans_path, notice: '您没有权限导出项目列表计划' 
      return
    end
    respond_to do |format|  
      format.csv { send_data Plan.to_csv }  
    end  
  end
  
  # GET /plans
  # GET /plans.json
  def index
    # @plans = Plan.where(plan_type: Plan::PLAN_TYPE[0]).all  #单一资金资管计划

    # @q = Plan.ransack(params[:q])
    # @plans = @q.result(distinct: true)
    @is_manager=Department.plan_manager?(current_user)
    @search = Plan.ransack(params[:q])
    # @search.sorts = 'name asc' if @search.sorts.empty?
    @plans = @search.result.paginate(:page => params[:page],:per_page => 8)

    # @plans = Plan.paginate(:page => params[:page], :per_page => 20).order("created_at desc")
  end

  # def search
  #   @q = Plan.ransack(params[:q])
  #   @plans = @q.result(distinct: true)
  # end

  # end

  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
    @plan.charge_amount=0.0
    @plan.department = current_user.current_department[0]
    if (@plan.cooperations.size == 0)
        @plan.cooperations.build
        @plan.cooperations[0].user = current_user
        @plan.cooperations[0].ratio = 1.0      
    end

    @departments = Plan.find_departments
  end

  # GET /plans/1/edit
  def edit
    unless Department.plan_manager?(current_user)
      redirect_to plans_path, notice: '您没有权限修改计划' 
      return 
    end

    @departments=Plan.find_departments
  end

  # POST /plans
  # POST /plans.json
  def create
    unless Department.plan_manager?(current_user)
      redirect_to plans_path, notice: '您没有权限修改计划' 
      return
    end

    @plan = Plan.new(plan_params)
    @plan.user=current_user
    respond_to do |format|
      if @plan.save
        format.html { redirect_to @plan, notice: '资管计划已成功创建.' }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    unless Department.plan_manager?(current_user)
      redirect_to plans_path, notice: '您没有权限修改计划' 
      return 
    end
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: '资管计划已更新.' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    unless Department.plan_manager?(current_user)
      redirect_to plans_path, notice: '您没有权限修改计划' 
      return 
    end
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to plans_url, notice: '资管计划将被删除！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
      @is_manager=Department.plan_manager?(current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:name, :this_amount, :year_amount, :start_date, :end_date, :management_fee, :investment_manager, :scale, :department_id, :rate, :fee, :notes, :plan_type, :annual, :risk, :parter, :model_type,:ownership_type,:charge_type, :charge_amount, :charge_date, cooperations_attributes: [:id, :user_id, :ratio, :_destroy])
    end
end
