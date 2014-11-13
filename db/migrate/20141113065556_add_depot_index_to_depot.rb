class AddDepotIndexToDepot < ActiveRecord::Migration
  def change
    add_column :depots, :index, :integer
  end
end
