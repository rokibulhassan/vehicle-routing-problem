class RouteCycle < ActiveRecord::Base
  serialize :nodes, Array

  scope :order_as_cost, -> { order('cost DESC') }
  scope :initialize, -> { where(status: 'initialize') }
  scope :improving, -> { where(status: 'improving') }
  scope :pending, -> { where(status: 'pending') }
  scope :complete, -> { where(status: 'complete') }


  def self.clarke_wright
    stopage ||= 9
    capacity ||= 40
    demands ||= [0, 10, 15, 18, 17, 3, 5, 9, 4, 6]
    costs ||= [[0, 12, 11, 7, 10, 10, 9, 8, 6, 12],
               [12, 0, 8, 5, 9, 12, 14, 16, 17, 22],
               [11, 8, 0, 9, 15, 17, 8, 18, 14, 22],
               [7, 5, 9, 0, 7, 9, 11, 12, 12, 17],
               [10, 9, 15, 7, 0, 3, 17, 7, 15, 18],
               [10, 12, 17, 9, 3, 0, 18, 6, 15, 15],
               [9, 14, 8, 11, 17, 18, 0, 16, 8, 16],
               [8, 16, 18, 12, 7, 6, 16, 0, 11, 11],
               [6, 17, 14, 12, 15, 15, 8, 11, 0, 10],
               [12, 22, 22, 17, 18, 15, 16, 11, 10, 0]]

    savings_computation(stopage, costs)
    route_extension(capacity, demands)
    cost_calculation
  end

  def self.savings_computation(stopage, costs)
    RouteCycle.destroy_all
    (1..stopage).each do |i|
      (i+1..stopage).each do |j|
        cost = costs[0][i] + costs[0][j] - costs[i][j]
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

  def sef.cost_calculation
    improving = RouteCycle.improving.order_as_cost
    #TODO calculate cost and Update stauts as complete
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