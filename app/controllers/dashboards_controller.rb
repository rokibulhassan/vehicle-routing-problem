class DashboardsController < ApplicationController
  def index
  end

  def optimum_route
    @routes = RouteCycle.optimize_routes
  end

  def view_on_map
    @routes = RouteCycle.optimize_coordinate
  end

  def test_map
    @routes = RouteCycle.optimize_coordinate
  end

  def reset_data
    RouteCycle.clarke_wright
  end
end
