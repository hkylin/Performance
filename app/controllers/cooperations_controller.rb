class CooperationsController < ApplicationController
  before_action :set_cooperation, only: [:show, :edit, :update, :destroy]

  # GET /cooperations
  # GET /cooperations.json
  def index
    @cooperations = Cooperation.all
  end

  # GET /cooperations/1
  # GET /cooperations/1.json
  def show
  end

  # GET /cooperations/new
  def new
    @cooperation = Cooperation.new
  end

  # GET /cooperations/1/edit
  def edit
  end

  # POST /cooperations
  # POST /cooperations.json
  def create
    @cooperation = Cooperation.new(cooperation_params)

    respond_to do |format|
      if @cooperation.save
        format.html { redirect_to @cooperation, notice: '协作者已成功创建.' }
        format.json { render :show, status: :created, location: @cooperation }
      else
        format.html { render :new }
        format.json { render json: @cooperation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cooperations/1
  # PATCH/PUT /cooperations/1.json
  def update
    respond_to do |format|
      if @cooperation.update(cooperation_params)
        format.html { redirect_to @cooperation, notice: '协作者已经被修改.' }
        format.json { render :show, status: :ok, location: @cooperation }
      else
        format.html { render :edit }
        format.json { render json: @cooperation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cooperations/1
  # DELETE /cooperations/1.json
  def destroy
    @cooperation.destroy
    respond_to do |format|
      format.html { redirect_to cooperations_url, notice: '协作者将被删除.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cooperation
      @cooperation = Cooperation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cooperation_params
      params.require(:cooperation).permit(:user_id, :project_modification_id, :ratio)
    end
end
