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

ActiveRecord::Schema.define(version: 20141115070924) do

  create_table "capacities", force: true do |t|
    t.integer  "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "depots", force: true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "demand"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "symmetric_costs"
    t.integer  "index"
  end

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "depot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "depot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_cycles", force: true do |t|
    t.string   "nodes"
    t.integer  "load"
    t.float    "cost"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: true do |t|
    t.string   "origin"
    t.string   "destination"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
