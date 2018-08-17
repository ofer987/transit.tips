class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :google_event_id, null: false
      t.references :calendar, index: true, foreign_key: true, null: false
      t.references :ttc_closure, index: true, foreign_key: true, null: false
      t.string :name, null: false
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end

    add_index :events, %i[id calendar_id], unique: true
  end
end
