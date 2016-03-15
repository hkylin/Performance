class ModificationsController < ApplicationController
  before_action :set_modification, only: [:show, :edit, :update, :destroy]
  # before_action :set_project, only: [:index, :new, :create]
  before_action :authenticate_user!

  # GET /modifications
  # GET /modifications.json
  def index
   if params[:project_id]
    @modificationable=Project.find(params[:project_id])
   else
    @modificationable=Plan.find(params[:plan_id])
   end
   @modifications = @modificationable.modifications
  end

  # GET /modifications/1
  # GET /modifications/1.json
  def show
  end

  # GET /modifications/new
  def new
    @modification = Modification.new
    @modificationable = find_modificationable
    logger.info "==========#{@modificationable}======"
    @modification.modificationable = @modificationable
    logger.info "==========#{@modification}======"
    logger.info '==========2======'
    # @select_projects=Modification.find_projects()
    @modification.start_date = @modificationable.start_date
    @modification.end_date = @modificationable.end_date
    @modification.rate = @modificationable.rate
    @modification.risk = @modificationable.risk
    @modification.annual = @modificationable.annual
    @modification.cooperations.build
    logger.info "==========#{@modification}======"
    logger.info '==========3======'
    # @modification.
  end

  # GET /modifications/1/edit
  def edit
    # @select_projects=Modification.find_projects()
    @modificationable=@modification.modificationable

    # puts Rails.application.assets.engines.to_yaml
    puts "|||||||||||||||||||||||||||||"
    puts @_lookup_context.inspect
    puts ActionView::Template::Handlers.extensions

  end

  # POST /modifications
  # POST /modifications.json
  def create
    @modification = Modification.new(modification_params)
    @modification.modificationable = find_modificationable

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
    # @select_projects=Modification.find_projects()
    logger.info modification_params
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
    logger.info modification_params
    @modificationable=@modification.modificationable
    @modification.destroy
    respond_to do |format|
      format.html { redirect_to project_modifications_url(@modificationable), notice: '项目更改将被删除.' }
      format.json { head :no_content }
    end
  end

  private
    # def set_project
    #   @project = Project.find(params[:project_id])
    # end

    # def find_modificationable   #gets the type of post to create
    #     params.each do |name, value|
    #         if name =~ /(.+)_id$/
    #             logger.info '---------++++++++++++----------'
    #             logger.info $1
    #             logger.info value
    #             logger.info $1.classify

    #             logger.info '---------++++++++++++----------'
    #             logger.info $1.classify.constantize
    #             logger.info $1.classify.constantize.find(value)
    #             return $1.classify.constantize.find(value)
    #         end
    #         nil
    #     end
    # end

    def find_modificationable
      if params[:project_id]
        Project.find(params[:project_id])
      else
        Plan.find(params[:plan_id])
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_modification
      @modification = Modification.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def modification_params
      params.require(:modification).permit(:project_id, :scale, :start_date, :end_date, :management_fee, :rate, :fee, :annual, :risk,:notes, cooperations_attributes: [:id, :user_id, :ratio, :_destroy])    
    end
end
