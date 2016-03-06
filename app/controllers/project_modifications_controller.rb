class ProjectModificationsController < ApplicationController
  before_action :set_project_modification, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:index, :new, :create]
  before_action :authenticate_user!

  # GET /project_modifications
  # GET /project_modifications.json
  def index
    @project_modifications = ProjectModification.all
  end

  # GET /project_modifications/1
  # GET /project_modifications/1.json
  def show
  end

  # GET /project_modifications/new
  def new
    @project_modification = ProjectModification.new
    @project_modification.project=@Project
    @select_projects=ProjectModification.find_projects()
  end

  # GET /project_modifications/1/edit
  def edit
    @select_projects=ProjectModification.find_projects()
    @project=@project_modification.project
  end

  # POST /project_modifications
  # POST /project_modifications.json
  def create
    @project_modification = ProjectModification.new(project_modification_params)
    @project_modification.project=@project

    respond_to do |format|
      if @project_modification.save
        format.html { redirect_to @project_modification, notice: 'Project modification was successfully created.' }
        format.json { render :show, status: :created, location: @project_modification }
      else
        format.html { render :new }
        format.json { render json: @project_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_modifications/1
  # PATCH/PUT /project_modifications/1.json
  def update
    @select_projects=ProjectModification.find_projects()
    respond_to do |format|
      if @project_modification.update(project_modification_params)
        format.html { redirect_to @project_modification, notice: 'Project modification was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_modification }
      else
        format.html { render :edit }
        format.json { render json: @project_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_modifications/1
  # DELETE /project_modifications/1.json
  def destroy
    @project=@project_modification.project
    @project_modification.destroy
    respond_to do |format|
      format.html { redirect_to project_project_modifications_url(@project), notice: 'Project modification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project_modification
      @project_modification = ProjectModification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_modification_params
      params.require(:project_modification).permit(:project_id, :start_date, :end_date, :management_fee, :rate, :fee, :notes, cooperations_attributes: [:id, :project_id, :ratio])
    end
end
