class AddExistingTables < ActiveRecord::Migration[5.1]
  def up
    create_table "tickets"
      t.string   "sb_bet_id"
      t.datetime "wager_date"
      t.string   "wager_type",     limit: 50
      t.float    "amount_wagered"
      t.float    "amount_to_win"
      t.string   "outcome",        limit: 50
      t.float    "amount_paid"
    end

    create_table "tags", force: :cascade do |t|
      t.string "name",   limit: 50
      t.float  "amount"
    end

    create_table "ticket_line_items", force: :cascade do |t|
      t.integer  "ticket_id"
      t.string   "away_team",        limit: 50
      t.integer  "away_score"
      t.string   "home_team",        limit: 50
      t.integer  "home_score"
      t.datetime "line_item_date"
      t.string   "line_item_spread", limit: 50
      t.string   "description"
    end

    create_table "ticket_tags", force: :cascade do |t|
      t.integer "ticket_id"
      t.integer "tag_id"
      t.float   "amount"
    end
  end


  def down
    drop_table "tickets"
    drop_table "tags"
    drop_table "ticket_line_items"
    drop_table "ticket_tags"
  end
end
