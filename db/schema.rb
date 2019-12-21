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

ActiveRecord::Schema.define(version: 2019_12_21_163129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "api_keys", id: :serial, force: :cascade do |t|
    t.string "access_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.float "amount"
  end

  create_table "clients", force: :cascade do |t|
    t.integer "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50
    t.float "amount"
  end

  create_table "ticket_line_items", id: :serial, force: :cascade do |t|
    t.integer "ticket_id"
    t.string "away_team", limit: 50
    t.integer "away_score"
    t.string "home_team", limit: 50
    t.integer "home_score"
    t.datetime "line_item_date"
    t.string "line_item_spread", limit: 50
    t.string "description"
  end

  create_table "ticket_tags", id: :serial, force: :cascade do |t|
    t.integer "ticket_id"
    t.integer "tag_id"
    t.float "amount"
    t.integer "client_id"
  end

  create_table "tickets", id: :serial, force: :cascade do |t|
    t.string "sb_bet_id"
    t.datetime "wager_date"
    t.string "wager_type", limit: 50
    t.float "amount_wagered"
    t.float "amount_to_win"
    t.string "outcome", limit: 50
    t.float "amount_paid"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "client_id"
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_sportsbook_username"
    t.string "encrypted_sportsbook_username_iv"
    t.string "encrypted_sportsbook_password"
    t.string "encrypted_sportsbook_password_iv"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ticket_line_items", "tickets", name: "ticket_line_items_ticket_fk"
  add_foreign_key "ticket_tags", "tags", name: "ticket_tags_tag_fk"
  add_foreign_key "ticket_tags", "tickets", name: "ticket_tags_ticket_fk"
end
