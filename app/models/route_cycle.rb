class RouteCycle < ActiveRecord::Base
  extend ApplicationHelper
  serialize :nodes, Array

  scope :order_as_cost, -> { order('cost DESC') }
  scope :initialize, -> { where(status: 'initialize') }
  scope :improving, -> { where(status: 'improving') }
  scope :pending, -> { where(status: 'pending') }
  scope :complete, -> { where(status: 'complete') }
  scope :optimized, -> { where(status: 'optimized') }


  def self.clarke_wright
    build_initial_cycle
    route_extension(capacity, demands)
    route_optimized!
    calculate_optimized_cost
  end

  def self.build_initial_cycle(costs=symmetric_costs)
    clean_cycle!
    (1..limit).each do |i|
      (i+1..limit).each do |j|
        cost = costs[0][i].to_f + costs[0][j].to_f - costs[i][j].to_f
        RouteCycle.create(nodes: [i, j], cost: cost, status: 'initialize')
      end
    end
  end

  def self.route_extension(capacity, demands)
    improving_initial_cycles(capacity, demands)
    improving_pending_cycles(capacity, demands)
  end

  def self.improving_initial_cycles(capacity, demands)
    initialized = RouteCycle.initialize.order_as_cost

    initialized.each_with_index do |route_cycle, index|
      node_1 = route_cycle.nodes[0]
      node_2 = route_cycle.nodes[1]
      improving = RouteCycle.improving.order_as_cost

      if improving.present?
        cycles_for_node_1 = improving.select { |rc| rc.nodes.include?(node_1) }.first
        cycles_for_node_2 = improving.select { |rc| rc.nodes.include?(node_2) }.first
        if cycles_for_node_1.present? && cycles_for_node_2.present?
          route_cycle.complete!
        elsif cycles_for_node_1.present? && !cycles_for_node_2.present?
          nodes = cycles_for_node_1.nodes << node_2
          load = demands[node_2] + cycles_for_node_1.load.to_i
          cycles_for_node_1.improve_old_cycle!(load, capacity, nodes, route_cycle)
        elsif !cycles_for_node_1.present? && cycles_for_node_2.present?
          nodes = cycles_for_node_2.nodes << node_1
          load = demands[node_1] + cycles_for_node_2.load.to_i
          cycles_for_node_2.improve_old_cycle!(load, capacity, nodes, route_cycle)
        elsif !cycles_for_node_1.present? && !cycles_for_node_2.present?
          nodes = route_cycle.nodes
          load = demands[node_1] + demands[node_2]
          route_cycle.make_initial_cycle!(load, capacity, nodes)
        end
      else
        nodes = route_cycle.nodes
        load = demands[node_1] + demands[node_2]
        route_cycle.make_initial_cycle!(load, capacity, nodes)
      end
    end
  end

  def self.improving_pending_cycles(capacity, demands)
    pending = RouteCycle.pending.order_as_cost

    pending.each do |route_cycle|
      node_1 = route_cycle.nodes[0]
      node_2 = route_cycle.nodes[1]
      improving = RouteCycle.improving.order_as_cost

      if improving.present?
        cycles_for_node_1 = improving.select { |rc| rc.nodes.include?(node_1) }.first
        cycles_for_node_2 = improving.select { |rc| rc.nodes.include?(node_2) }.first
        if cycles_for_node_1.present? && cycles_for_node_2.present?
          route_cycle.complete!
        elsif cycles_for_node_1.present? && !cycles_for_node_2.present?
          nodes = cycles_for_node_1.nodes << node_2
          load = demands[node_2] + cycles_for_node_1.load.to_i
          cycles_for_node_1.improve_pending_cycle!(load, capacity, nodes, demands, node_2, route_cycle)
        elsif !cycles_for_node_1.present? && cycles_for_node_2.present?
          nodes = cycles_for_node_2.nodes << node_1
          load = demands[node_1] + cycles_for_node_2.load.to_i
          cycles_for_node_2.improve_pending_cycle!(load, capacity, nodes, demands, node_1, route_cycle)
        elsif !cycles_for_node_1.present? && !cycles_for_node_2.present?
          nodes = route_cycle.nodes
          load = demands[node_1] + demands[node_2]
          route_cycle.improve_new_from_pending_cycle!(load, capacity, nodes, demands)
        end
      end
    end
  end

  def self.route_optimized!
    improving = RouteCycle.improving.order_as_cost
    improving.collect(&:optimized!)
  end

  def self.optimize_routes
    paths = []
    routes = RouteCycle.optimized
    center = Depot.where(index: 0).first
    routes.each do |route|
      cycle = []
      cycle << center.name
      route.nodes.each do |node|
        cycle << Depot.where(index: node).first.name
      end
      cycle << center.name
      cycle.flatten!
      paths << [id: route.id, name: cycle, demand: route.load, cost: route.cost]
    end
    puts "#{paths.inspect}"
    paths
  end


  def self.calculate_optimized_cost
    routes = RouteCycle.optimized
    center = Depot.where(index: 0).first
    routes.each do |route|
      cycle = []
      cost = 0
      cycle << center
      route.nodes.each do |node|
        cycle << Depot.where(index: node).first
      end
      cycle << center
      cycle.flatten!

      cycle.each_cons(2) do |depot, next_depot|
        puts ">>>> #{[depot.index, next_depot.index]} > #{symmetric_costs[depot.index][next_depot.index].to_f}"
        cost += symmetric_costs[depot.index][next_depot.index].to_f
      end
      route.update_column(:cost, cost)
    end
  end


  def self.optimize_coordinate
    coordinates = []
    routes = RouteCycle.optimized
    center = Depot.where(index: 0).first
    routes.each do |route|
      cycle = []
      nodes = []
      cycle << center
      cycle << Depot.where(index: route.nodes)
      cycle << center
      cycle.flatten!

      cycle.each_cons(2) do |depot, next_depot|
        start_node = [depot.latitude, depot.longitude]
        end_node = [next_depot.latitude, next_depot.longitude]
        nodes << [start_node, end_node]
      end
      coordinates << nodes
    end
    coordinates
  end

  def make_initial_cycle!(load, capacity, nodes)
    load <= capacity ? self.improve_cycle!(load, nodes) : self.pending!
  end

  def improve_old_cycle!(load, capacity, nodes, initial_cycle)
    load <= capacity ? self.improve_cycle!(load, nodes) : initial_cycle.pending!
  end

  def improve_pending_cycle!(load, capacity, nodes, demands, node, initial_cycle)
    load <= capacity ? self.improve_cycle!(load, nodes) : initial_cycle.improve_cycle!(demands[node], [node])
  end

  def improve_new_from_pending_cycle!(load, capacity, nodes, demands)
    if load <= capacity
      self.improve_cycle!(load, nodes)
    else
      self.nodes.each do |n|
        RouteCycle.create(nodes: [n], load: demands[n], status: 'improving')
      end
    end
  end

  def complete!
    self.update_column(:status, 'complete')
  end

  def pending!
    self.update_column(:status, 'pending')
  end

  def optimized!
    self.update_column(:status, 'optimized')
  end

  def get_nodes(node)
    return self.nodes << node
  end

  def get_load(demands, node)
    demands[node] + self.load.to_i
  end

  def improve_cycle!(load, nodes)
    self.load = load
    self.nodes = nodes
    self.status = 'improving'
    self.save
  end

end