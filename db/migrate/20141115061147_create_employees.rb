class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :title
      t.integer :depot_id

      t.timestamps
    end
  end
end
