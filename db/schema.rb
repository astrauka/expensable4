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

ActiveRecord::Schema.define(version: 20140624184141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expenses", force: true do |t|
    t.integer  "creator_id"
    t.integer  "group_id"
    t.integer  "payer_id"
    t.boolean  "hidden",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "spent_cents", default: 0,     null: false
  end

  add_index "expenses", ["creator_id"], name: "index_expenses_on_creator_id", using: :btree
  add_index "expenses", ["group_id", "payer_id", "hidden"], name: "index_expenses_on_group_id_and_payer_id_and_hidden", using: :btree
  add_index "expenses", ["group_id"], name: "index_expenses_on_group_id", using: :btree
  add_index "expenses", ["payer_id"], name: "index_expenses_on_payer_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invites", force: true do |t|
    t.integer  "group_id"
    t.boolean  "accepted",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
  end

  add_index "invites", ["group_id"], name: "index_invites_on_group_id", using: :btree
  add_index "invites", ["uid"], name: "index_invites_on_uid", using: :btree

  create_table "shares", force: true do |t|
    t.integer  "expense_id"
    t.integer  "multiplier"
    t.integer  "single_price_cents", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "shares", ["expense_id"], name: "index_shares_on_expense_id", using: :btree
  add_index "shares", ["user_id", "expense_id"], name: "index_shares_on_user_id_and_expense_id", using: :btree

  create_table "user_group_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",        default: true
    t.integer  "balance_cents", default: 0,    null: false
  end

  add_index "user_group_relationships", ["group_id", "user_id"], name: "index_user_group_relationships_on_group_id_and_user_id", using: :btree
  add_index "user_group_relationships", ["user_id"], name: "index_user_group_relationships_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
