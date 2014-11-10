class CreateRouteCycle < ActiveRecord::Migration
  def change
    create_table :route_cycles do |t|
      t.string :nodes
      t.integer :load
      t.float :cost
      t.string :status

      t.timestamps
    end
  end
end
