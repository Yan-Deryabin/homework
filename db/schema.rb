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

ActiveRecord::Schema.define(version: 20180603131839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "name"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "product_id"
    t.float "avg_rating"
    t.integer "rate_count"
    t.date "analyse_date"
    t.index ["analyse_date"], name: "index_ratings_on_analyse_date"
    t.index ["product_id", "analyse_date"], name: "index_ratings_on_product_id_and_analyse_date", unique: true
    t.index ["product_id"], name: "index_ratings_on_product_id"
  end

end
