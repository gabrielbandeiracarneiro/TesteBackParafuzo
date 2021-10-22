# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_22_183603) do

  create_table "parkings", force: :cascade do |t|
    t.string "plate"
    t.string "reservation"
    t.string "time"
    t.boolean "paid"
    t.boolean "left"
    t.datetime "entryDate"
    t.datetime "paidDate"
    t.datetime "exitDate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plate"], name: "index_parkings_on_plate"
  end

end
