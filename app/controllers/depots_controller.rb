class DepotsController < ApplicationController
  before_action :set_depot, only: [:show, :edit, :update, :destroy]

  def index
    @depots = Depot.re_order
  end

  def show
  end

  def new
    @depot = Depot.new
  end

  def edit
  end

  def create
    @depot = Depot.new(depot_params)

    respond_to do |format|
      if @depot.save
        format.html { redirect_to depots_url, notice: 'Depot was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @depot.update(depot_params)
        format.html { redirect_to depots_url, notice: 'Depot was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @depot.destroy
    respond_to do |format|
      format.html { redirect_to depots_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_depot
    @depot = Depot.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def depot_params
    params.require(:depot).permit(:latitude, :longitude, :name, :demand, :symmetric_costs, :index)
  end
end
