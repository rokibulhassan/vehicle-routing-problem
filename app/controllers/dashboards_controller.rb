class DashboardsController < ApplicationController
  def index
    render :layout => false
  end

  def optimum_route
    @routes = RouteCycle.optimize_routes
  end

  def view_on_map
    @routes = RouteCycle.optimize_coordinate
  end

  def show_routes
    @start = Depot.where(index: 0).first
    route = RouteCycle.find(params[:route_cycle_id])
    @depots = Depot.where(index: route.nodes)
    render :layout => false
  end

  def reset_data
    RouteCycle.clarke_wright
    respond_to do |format|
      format.html { redirect_to optimum_route_dashboards_path, notice: 'Path Executed successfully.' }
    end
  end
end
