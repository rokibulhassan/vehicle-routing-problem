class AddSymmetricCostsToDepot < ActiveRecord::Migration
  def change
    add_column :depots, :symmetric_costs, :string
  end
end
