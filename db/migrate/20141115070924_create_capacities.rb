class CreateCapacities < ActiveRecord::Migration
  def change
    create_table :capacities do |t|
      t.integer :limit

      t.timestamps
    end
  end
end
