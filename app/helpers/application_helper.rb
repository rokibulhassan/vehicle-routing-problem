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

  def capacity
    Capacity.last.try(:limit) || 40
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

  def clean_employee!
    Employee.destroy_all
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
    Depot.create(name: "Mohakhali DOHS, Dhaka, Bangladesh", latitude: 23.7795, longitude: 90.3946, index: 0, demand: 0, symmetric_costs: "0, 12, 11, 7, 10, 10, 9, 8, 6, 12")
    Depot.create(name: "Mirpur-10, Begum Rokeya Avenue, Dhaka 1216, Bangladesh", latitude: 23.8071, longitude: 90.3686, index: 1, demand: 10, symmetric_costs: "12, 0, 8, 5, 9, 12, 14, 16, 17, 22")
    Depot.create(name: "House Building Bus Stop, Dhaka - Mymensingh Highway, Dhaka 1230, Bangladesh", latitude: 23.874, longitude: 90.4007, index: 2, demand: 15, symmetric_costs: "11, 8, 0, 9, 15, 17, 8, 18, 14, 22")
    Depot.create(name: "Uttar Badda, Dhaka, Bangladesh", latitude: 23.7806, longitude: 90.4255, index: 3, demand: 18, symmetric_costs: "7, 5, 9, 0, 7, 9, 11, 12, 12, 17")
    Depot.create(name: "Shegunbagicha, Dhaka, Bangladesh", latitude: 23.7355, longitude: 90.404, index: 4, demand: 17, symmetric_costs: "10, 9, 15, 7, 0, 3, 17, 7, 15, 18")
    Depot.create(name: "Dhanmondi, Dhaka, Bangladesh", latitude: 23.745, longitude: 90.3781, index: 5, demand: 3, symmetric_costs: "10, 12, 17, 9, 3, 0, 18, 6, 15, 15")
    Depot.create(name: "31/1 Azimpur Road, Dhaka, Bangladesh", latitude: 23.7228, longitude: 90.3876, index: 6, demand: 5, symmetric_costs: "9, 14, 8, 11, 17, 18, 0, 16, 8, 16")
    Depot.create(name: "Mohammadpur, Dhaka, Bangladesh", latitude: 23.7624, longitude: 90.3589, index: 7, demand: 9, symmetric_costs: "8, 16, 18, 12, 7, 6, 16, 0, 11, 11")
    Depot.create(name: "Khamar Bari Road, Dhaka 1215, Bangladesh", latitude: 23.7593, longitude: 90.3889, index: 8, demand: 4, symmetric_costs: "6, 17, 14, 12, 15, 15, 8, 11, 0, 10")
    Depot.create(name: "Agargaon, Dhaka, Bangladesh", latitude: 23.7785, longitude: 90.3797, index: 9, demand: 6, symmetric_costs: "12, 22, 22, 17, 18, 15, 16, 11, 10, 0")
  end

  def populate_employee
    clean_employee!
    depots.each do |depot|
      depot.demand.times do |n|
        Employee.create(name: "Rokibul Hasan #{depot.index}-#{n}", title: "Software Engineer", depot_id: depot.id)
      end
    end
  end
end
