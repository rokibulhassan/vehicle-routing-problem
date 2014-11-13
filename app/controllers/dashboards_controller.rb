class DashboardsController < ApplicationController
  def index
  end

  def optimum_route
    @routes = RouteCycle.optimize_coordinate
    end

  def test_map
    @routes = RouteCycle.optimize_coordinate
  end
end
