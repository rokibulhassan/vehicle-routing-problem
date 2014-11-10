module ClearkWrightAlgorith

  class Saving

    def initialize
      @node = 9
      @capacity = 40
      @demands = [0, 10, 15, 18, 17, 3, 5, 9, 4, 6]
      @costs = [[0, 12, 11, 7, 10, 10, 9, 8, 6, 12],
                [12, 0, 8, 5, 9, 12, 14, 16, 17, 22],
                [11, 8, 0, 9, 15, 17, 8, 18, 14, 22],
                [7, 5, 9, 0, 7, 9, 11, 12, 12, 17],
                [10, 9, 15, 7, 0, 3, 17, 7, 15, 18],
                [10, 12, 17, 9, 3, 0, 18, 6, 15, 15],
                [9, 14, 8, 11, 17, 18, 0, 16, 8, 16],
                [8, 16, 18, 12, 7, 6, 16, 0, 11, 11],
                [6, 17, 14, 12, 15, 15, 8, 11, 0, 10],
                [12, 22, 22, 17, 18, 15, 16, 11, 10, 0]]
    end

    def solution
      savings = savings_computation
      savings = improve_savings(savings)
      #route_extension(savings)
    end

    def savings_computation
      savings = {}
      (1..@node).each do |i|
        (i+1..@node).each do |j|
          cost = @costs[0][i] + @costs[0][j] - @costs[i][j]
          savings.merge!({[i, j] => cost})
        end
      end
      savings.sort { |a1, a2| a2[1].to_i <=> a1[1].to_i }
    end

    def improve_savings(savings)
      savings.each do |edge, cost|
        RouteCycle.create(node: edge, cost: cost, status: 'initialize')
      end
    end

    def route_extension(savings)
      cycles = {}
      savings.each_with_index do |edge, index|
        #Edge [4,5]: Join cycles 0-4-0 and 0-5-0: result 0-4-5-0, load d4 + d5 = 20 < K.
        #Edge [1,2]: Join 0-1-0 and 0-2-0: result 0-1-2-0, load d + d = 25 < K. 1 2
        #Edge [1,3]: Capacity limit: d +d +d = 43 > K
        load = 0
        build_cycle = []

        edge.each do |node|
          load += @demands[node]
          build_cycle << node
        end

        if load < @capacity
          data = savings[index].replace(build_cycle)
          puts "savings:: #{data}"
          route_extension(data)
          #cycles.merge!({build_cycle => load})
        end
      end
    end

  end
end