module ApplicationHelper

  def depots
    Depot.all
  end

  def depots_size
    depots.size
  end

  def limit
    depots_size - 1
  end

  def demands
    depots.collect(&:demand)
  end

  def clean_cycle!
    RouteCycle.destroy_all
  end

  def clean_depot!
    Depot.destroy_all
  end

  def symmetric_costs
    symmetric_costs = []
    depots.each do |depot|
      symmetric_costs << depot.symmetric_costs.split(/\,/).map(&:strip)
    end
    symmetric_costs
  end

  def create_depots
    clean_depot!
    Depot.create(name: "Tejgaon Circle#1, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 0, symmetric_costs: "0, 12, 11, 7, 10, 10, 9, 8, 6, 12")
    Depot.create(name: "Tejgaon Circle#2, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 10, symmetric_costs: "12, 0, 8, 5, 9, 12, 14, 16, 17, 22")
    Depot.create(name: "Tejgaon Circle#3, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 15, symmetric_costs: "11, 8, 0, 9, 15, 17, 8, 18, 14, 22")
    Depot.create(name: "Tejgaon Circle#4, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 18, symmetric_costs: "7, 5, 9, 0, 7, 9, 11, 12, 12, 17")
    Depot.create(name: "Tejgaon Circle#5, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 17, symmetric_costs: "10, 9, 15, 7, 0, 3, 17, 7, 15, 18")
    Depot.create(name: "Tejgaon Circle#6, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 3, symmetric_costs: "10, 12, 17, 9, 3, 0, 18, 6, 15, 15")
    Depot.create(name: "Tejgaon Circle#7, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 5, symmetric_costs: "9, 14, 8, 11, 17, 18, 0, 16, 8, 16")
    Depot.create(name: "Tejgaon Circle#8, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 9, symmetric_costs: "8, 16, 18, 12, 7, 6, 16, 0, 11, 11")
    Depot.create(name: "Tejgaon Circle#9, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 4, symmetric_costs: "6, 17, 14, 12, 15, 15, 8, 11, 0, 10")
    Depot.create(name: "Tejgaon Circle#10, Bangladesh", latitude: 23.811, longitude: 90.414, demand: 6, symmetric_costs: "12, 22, 22, 17, 18, 15, 16, 11, 10, 0")
  end

end
