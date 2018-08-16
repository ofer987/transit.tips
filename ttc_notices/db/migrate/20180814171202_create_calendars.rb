class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :google_calendar_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :calendars, :google_calendar_id, unique: true
  end
end
