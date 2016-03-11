class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_plan, only: [:index, :new, :create]
  before_action :authenticate_user!

  # GET /projects
  # GET /projects.json
  def index
    # @projects = Project.all
    @projects = @plan.projects
    # @plans = current_user.plans
    # @projects = current_user.projects
    # @tasks = current_user.tasks
  end

  def all
    # @projects = Project.all
    @projects = current_user.projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.plan = @Plan
    @project.rate = @plan.rate
    @project.risk = @plan.risk
    @project.department = @plan.department
    @project.parter = @plan.parter
    @project.annual = @plan.annual
    
    @departments=Plan.find_departments
    # @plans=Plan.find_plans

  end

  # GET /projects/1/edit
  def edit
    @departments=Plan.find_departments
    @plan=@project.plan
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.plan=@plan
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: '成功创建新项目' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_path(@project), notice: '项目已经被更新！' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @plan=@project.plan
    @project.destroy
    respond_to do |format|
      format.html { redirect_to plan_projects_url(@plan), notice: '项目将被删除，其相关的项目修改也将会被删除！' }
      format.json { head :no_content }
    end
  end
  
  protected
    def set_plan
      @plan = Plan.find(params[:plan_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:plan_id, :number, :name, :scale, :start_date, :end_date, :management_fee, :investment_manager, :parter, :department_id, :rate, :fee, :annual, :risk, :notes)
    end
end
