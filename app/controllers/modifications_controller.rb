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
    @is_project = (@modificationable.class == Project)
    logger.info "==========#{@modificationable}======"
    @modification.modificationable = @modificationable
    logger.info "==========#{@modification}======"
    logger.info '==========2======'
    # @select_projects=Modification.find_projects()
    @modification.start_date = @modificationable.start_date
    @modification.end_date = @modificationable.end_date
    @modification.scale = @modificationable.scale
    @modification.rate = @modificationable.rate
    @modification.risk = @modificationable.risk
    @modification.annual = @modificationable.annual
    @modification.charge_type = Modification::CHARGE_TYPE[0]
    @modification.charge_amount = 0.0
    @modification.channel_cost = @modificationable.channel_cost if (@modificationable.class == Project)
    @modificationable.cooperations.each do |co|
      co1 = co.dup
      co1.cooperationable = @modification
      @modification.cooperations << co1
    end
    logger.info "==========#{@modification}======"
    logger.info '==========3======'
  end

  # GET /modifications/1/edit
  def edit
    # @select_projects=Modification.find_projects()
    @modificationable = @modification.modificationable
    @is_project = (@modificationable.class == Project)
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
    @modification.name = @modification.modificationable.name
    @modification.channel_cost=0.0 if (@modification.modificationable.class == Plan)
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
    @modificationable = @modification.modificationable
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
    @modificationable=@modification.modificationable
    is_project = (@modificationable.class == Project)
    @modification.destroy

    respond_to do |format|
      if(is_project)
        format.html { redirect_to project_modifications_url(@modificationable), notice: '项目更改将被删除.' }
      else
        format.html { redirect_to plan_modifications_url(@modificationable), notice: '项目更改将被删除.' }
      end
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
      params.require(:modification).permit(:project_id, :scale, :start_date, :end_date, :management_fee, :rate, :fee, :annual, :risk,:notes, :charge_type, :charge_amount,:charge_date, :channel_cost, cooperations_attributes: [:id, :user_id, :ratio, :co_type, :_destroy])    
    end
end
