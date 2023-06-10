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

ActiveRecord::Schema[7.0].define(version: 2023_06_09_120252) do
  create_table "mask_transactions", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "purchase_at", null: false
    t.bigint "user_id", null: false
    t.bigint "pharmacy_id", null: false
    t.bigint "pharmacy_mask_id", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["pharmacy_id"], name: "index_mask_transactions_on_pharmacy_id"
    t.index ["pharmacy_mask_id"], name: "index_mask_transactions_on_pharmacy_mask_id"
    t.index ["user_id"], name: "index_mask_transactions_on_user_id"
  end

  create_table "masks", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.boolean "is_available", default: true, null: false
  end

  create_table "pharmacies", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.decimal "cash_balance", precision: 10, scale: 2, default: "0.0", null: false
    t.json "open_hours", null: false
  end

  create_table "pharmacy_masks", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pharmacy_id", null: false
    t.bigint "mask_id", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["mask_id"], name: "index_pharmacy_masks_on_mask_id"
    t.index ["pharmacy_id"], name: "index_pharmacy_masks_on_pharmacy_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.decimal "cash_balance", precision: 10, scale: 2, default: "0.0", null: false
  end

  add_foreign_key "mask_transactions", "pharmacies"
  add_foreign_key "mask_transactions", "pharmacy_masks"
  add_foreign_key "mask_transactions", "users"
  add_foreign_key "pharmacy_masks", "masks"
  add_foreign_key "pharmacy_masks", "pharmacies"
end
