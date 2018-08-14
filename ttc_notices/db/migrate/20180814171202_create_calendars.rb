class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :calendar_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :calendars, :calendar_id, unique: true
  end
end
