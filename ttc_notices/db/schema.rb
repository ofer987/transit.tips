# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180814171405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendars", force: :cascade do |t|
    t.string   "google_calendar_id", null: false
    t.string   "name",               null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "calendars", ["google_calendar_id"], name: "index_calendars_on_google_calendar_id", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "google_event_id", null: false
    t.integer  "calendar_id",     null: false
    t.integer  "ttc_closure_id",  null: false
    t.string   "name",            null: false
    t.text     "description",     null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "events", ["calendar_id"], name: "index_events_on_calendar_id", using: :btree
  add_index "events", ["id", "calendar_id"], name: "index_events_on_id_and_calendar_id", unique: true, using: :btree
  add_index "events", ["ttc_closure_id"], name: "index_events_on_ttc_closure_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.integer  "tweet_id",    limit: 8, null: false
    t.integer  "line_id",               null: false
    t.string   "line_type",             null: false
    t.text     "description",           null: false
    t.datetime "tweeted_at",            null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "statuses", ["tweet_id", "line_id"], name: "index_statuses_on_tweet_id_and_line_id", unique: true, using: :btree

  create_table "ttc_closures", force: :cascade do |t|
    t.integer  "line_id",           null: false
    t.string   "from_station_name", null: false
    t.string   "to_station_name",   null: false
    t.datetime "start_at",          null: false
    t.datetime "end_at",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "ttc_closures", ["line_id", "from_station_name", "to_station_name", "start_at", "end_at"], name: "almost_all_the_columns", unique: true, using: :btree

  add_foreign_key "events", "calendars"
  add_foreign_key "events", "ttc_closures"
end
