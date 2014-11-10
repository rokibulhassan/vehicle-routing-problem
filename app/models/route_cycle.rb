class RouteCycle < ActiveRecord::Base
  serialize :nodes, Array

  scope :order_as_cost, -> { order('cost DESC') }
  scope :improving, -> { where(status: 'improving') }
  scope :pending, -> { where(status: 'pending') }
  scope :complete, -> { where(status: 'complete') }

  def self.savings_computation(stopage=9, costs = [[0, 12, 11, 7, 10, 10, 9, 8, 6, 12],
                                                   [12, 0, 8, 5, 9, 12, 14, 16, 17, 22],
                                                   [11, 8, 0, 9, 15, 17, 8, 18, 14, 22],
                                                   [7, 5, 9, 0, 7, 9, 11, 12, 12, 17],
                                                   [10, 9, 15, 7, 0, 3, 17, 7, 15, 18],
                                                   [10, 12, 17, 9, 3, 0, 18, 6, 15, 15],
                                                   [9, 14, 8, 11, 17, 18, 0, 16, 8, 16],
                                                   [8, 16, 18, 12, 7, 6, 16, 0, 11, 11],
                                                   [6, 17, 14, 12, 15, 15, 8, 11, 0, 10],
                                                   [12, 22, 22, 17, 18, 15, 16, 11, 10, 0]])
    (1..stopage).each do |i|
      (i+1..stopage).each do |j|
        cost = costs[0][i] + costs[0][j] - costs[i][j]
        RouteCycle.create(nodes: [i, j], cost: cost, status: 'initialize')
      end
    end
  end

  def self.route_extension(capacity=40, demands = [0, 10, 15, 18, 17, 3, 5, 9, 4, 6])
    route_cycles = RouteCycle.order_as_cost

    route_cycles.each do |route_cycle|
      route_cycle.nodes.each do |node|

        #Search Improving Cycle for nodes
        old_cycles = RouteCycle.improving.select { |rc| rc.nodes.include?(node) }

        if old_cycles.present?
          new_node = route_cycle.nodes.reject { |n| n == node }[0]
          load = demands[new_node]
          old_cycles.each do |old_cycle|

            load += old_cycle.load
            old_nodes = old_cycle.nodes

            logger.info [new_node, old_nodes]

            if load < capacity
              if old_nodes.exclude?(new_node)
                old_cycle.improve_cycle!(load, old_nodes << new_node)
              else
                route_cycle.update_column(:status, 'complete')
              end
            end
          end

        else

          #Build default cycle with existing nodes
          load = 0
          load += demands[node].to_i
          load < capacity ? route_cycle.improve_cycle!(load, route_cycle.nodes) : route_cycle.update_column(:status, 'pending')

        end
      end
    end

  end

  def improve_cycle!(load, edges)
    logger.info "Updating #{self.id} nodes: #{nodes}"
    self.load = load
    self.nodes = edges
    self.status = 'improving'
    self.save
  end

end