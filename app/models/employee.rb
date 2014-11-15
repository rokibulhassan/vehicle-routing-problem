class Employee < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :depot

  def self.create_employee
    populate_employee
  end
end
