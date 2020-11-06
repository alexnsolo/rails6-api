# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_06_192243) do

  create_table "grant_awards", force: :cascade do |t|
    t.integer "grant_recipient_id", null: false
    t.integer "grant_filing_id", null: false
    t.float "amount"
    t.string "purpose"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grant_filing_id"], name: "index_grant_awards_on_grant_filing_id"
    t.index ["grant_recipient_id"], name: "index_grant_awards_on_grant_recipient_id"
  end

  create_table "grant_filers", force: :cascade do |t|
    t.string "ein"
    t.string "name"
    t.string "line_1"
    t.string "line_2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ein"], name: "index_grant_filers_on_ein", unique: true
  end

  create_table "grant_filings", force: :cascade do |t|
    t.integer "grant_filer_id", null: false
    t.string "url"
    t.integer "tax_year"
    t.datetime "tax_period_begin_date"
    t.datetime "tax_period_end_date"
    t.datetime "timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grant_filer_id"], name: "index_grant_filings_on_grant_filer_id"
    t.index ["url"], name: "index_grant_filings_on_url", unique: true
  end

  create_table "grant_recipients", force: :cascade do |t|
    t.string "ein"
    t.string "name"
    t.string "line_1"
    t.string "line_2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ein"], name: "index_grant_recipients_on_ein", unique: true
  end

  add_foreign_key "grant_awards", "grant_filings"
  add_foreign_key "grant_awards", "grant_recipients"
  add_foreign_key "grant_filings", "grant_filers"
end
