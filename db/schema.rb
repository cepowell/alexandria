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

ActiveRecord::Schema.define(version: 20160404012452) do

# Could not dump table "collections" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "documents", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "collections_id"
    t.string   "name"
    t.boolean  "isPublished"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "body"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  add_index "documents", ["collections_id"], name: "index_documents_on_collections_id"
  add_index "documents", ["users_id"], name: "index_documents_on_users_id"

  create_table "permissions", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "documents_id"
    t.string   "access"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "permissions", ["documents_id"], name: "index_permissions_on_documents_id"
  add_index "permissions", ["users_id"], name: "index_permissions_on_users_id"

  create_table "users", force: :cascade do |t|
    t.integer  "uid",             null: false
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.string   "password"
    t.boolean  "emailOptOut"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "provider"
  end

end
