class RaspisController < ApplicationController
  before_action :set_raspi, only: [:show, :edit, :update, :destroy]
  
  def send_message
    Streammie::Send( "Send(#{params[:port]}, test_message)" )
  end
  
  def reconnect
    Streammie::Send( "Reconnect(#{params[:port]})" )
  end
  
  # GET /raspis
  # GET /raspis.json
  def index
    @raspis = Raspi.all
  end

  # GET /raspis/1
  # GET /raspis/1.json
  def show
  end

  # GET /raspis/new
  def new
    @raspi = Raspi.new
  end

  # GET /raspis/1/edit
  def edit
  end

  # POST /raspis
  # POST /raspis.json
  def create
    @raspi = Raspi.new(raspi_params)

    respond_to do |format|
      if @raspi.save
        format.html { redirect_to raspis_url, notice: 'Raspi was successfully created.' }
        format.json { render status: :created, location: @raspi }
      else
        format.html { render action: 'new' }
        format.json { render json: @raspi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /raspis/1
  # PATCH/PUT /raspis/1.json
  def update
    respond_to do |format|
      if @raspi.update(raspi_params)
        format.html { redirect_to raspis_url, notice: 'Raspi was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @raspi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /raspis/1
  # DELETE /raspis/1.json
  def destroy
    @raspi.destroy
    respond_to do |format|
      format.html { redirect_to raspis_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raspi
      @raspi = Raspi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raspi_params
      params.require(:raspi).permit(:label, :ipv4, :user_id)
    end
end
