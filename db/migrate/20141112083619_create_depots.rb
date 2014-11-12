class CreateDepots < ActiveRecord::Migration
  def change
    create_table :depots do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.integer :demand
      t.string :type

      t.timestamps
    end
  end
end
