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

ActiveRecord::Schema.define(version: 20170214012919) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "location_id"
    t.integer "item_id"
    t.integer "review_id"
    t.integer "image_id"
  end

  create_table "images", force: :cascade do |t|
    t.string  "cloudinary_id"
    t.integer "location_id"
    t.integer "item_id"
    t.integer "review_id"
    t.integer "location_banner"
    t.integer "review_banner"
    t.integer "item_banner"
    t.integer "user_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "item_id"
    t.string   "description"
    t.integer  "rating"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "fb_user_id"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
  end

end
