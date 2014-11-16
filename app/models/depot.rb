class Depot < ActiveRecord::Base
  has_many :employees
  scope :re_order, -> { order('depots.index ASC') }
end