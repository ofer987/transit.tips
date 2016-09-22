class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.bigint :tweet_id, null: false
      t.integer :line_id, null: false
      t.string :line_type, null: false
      t.text :description, null: false
      t.datetime :tweeted_at, null: false

      t.timestamps null: false

      t.index [:tweet_id, :line_id], unique: true
    end
  end
end
