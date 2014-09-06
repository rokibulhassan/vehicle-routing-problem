class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :origin
      t.string :destination

      t.timestamps
    end
  end
end
