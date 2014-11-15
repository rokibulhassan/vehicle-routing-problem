class GenerateEmployee < ActiveRecord::Migration
  def self.up
    Employee.create_employee
  end
end
