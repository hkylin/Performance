class ModificationsController < ApplicationController
  before_action :set_modification, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:index, :new, :create]
  before_action :authenticate_user!

  # GET /modifications
  # GET /modifications.json
  def index
    @modifications = Modification.all
  end

  # GET /modifications/1
  # GET /modifications/1.json
  def show
  end

  # GET /modifications/new
  def new
    @modification = Modification.new
    @modification.project=@Project
    @select_projects=Modification.find_projects()
    @modification.start_date = @project.start_date
    @modification.end_date = @project.end_date
    @modification.rate = @project.rate
    @modification.risk = @project.risk
    @modification.annual = @project.annual
    # @modification.
  end

  # GET /modifications/1/edit
  def edit
    @select_projects=Modification.find_projects()
    @project=@modification.project
  end

  # POST /modifications
  # POST /modifications.json
  def create
    @modification = Modification.new(modification_params)
    @modification.project=@project

    respond_to do |format|
      if @modification.save
        format.html { redirect_to @modification, notice: '成功创建项目跳转' }
        format.json { render :show, status: :created, location: @modification }
      else
        format.html { render :new }
        format.json { render json: @modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modifications/1
  # PATCH/PUT /modifications/1.json
  def update
    @select_projects=Modification.find_projects()
    respond_to do |format|
      if @modification.update(modification_params)
        format.html { redirect_to @modification, notice: '项目调整已更新.' }
        format.json { render :show, status: :ok, location: @modification }
      else
        format.html { render :edit }
        format.json { render json: @modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modifications/1
  # DELETE /modifications/1.json
  def destroy
    @project=@modification.project
    @modification.destroy
    respond_to do |format|
      format.html { redirect_to project_modifications_url(@project), notice: '项目更改将被删除.' }
      format.json { head :no_content }
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_modification
      @modification = Modification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modification_params
      params.require(:modification).permit(:project_id, :scale, :start_date, :end_date, :management_fee, :rate, :fee, :annual, :risk,:notes, cooperations_attributes: [:id, :project_id, :ratio])
    end
end
