class CreateTtcClosures < ActiveRecord::Migration
  def change
    create_table :ttc_closures do |t|
      t.integer :line_id, null: false
      t.string :from_station_name, null: false
      t.string :to_station_name, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps null: false

      t.index %i[line_id from_station_name to_station_name start_at end_at], unique: true, name: 'almost_all_the_columns'
    end
  end
end
