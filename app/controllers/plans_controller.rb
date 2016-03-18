class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /plans
  # GET /plans.json
  def index
    # @plans = Plan.where(plan_type: Plan::PLAN_TYPE[0]).all  #单一资金资管计划
    @plans = current_user.plans
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
    @plan.plan_type = Plan::PLAN_TYPE[0]
    @plan.entrust_type = Plan::ENTRUST_TYPE[0]
    @plan.risk = Plan::RISK_TYPE[0]
    @plan.scale = 30000000.0
    @departments = Plan.find_departments
  end

  # GET /plans/1/edit
  def edit
    @departments=Plan.find_departments
  end

  # POST /plans
  # POST /plans.json
  def create
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
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:number, :name, :this_amount, :year_amount, :start_date, :end_date, :management_fee, :investment_manager, :scale, :department_id, :rate, :fee, :notes, :plan_type, :entrust_type, :annual, :risk, :parter, cooperations_attributes: [:id, :user_id, :ratio, :_destroy])
    end
end
