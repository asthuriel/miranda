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

ActiveRecord::Schema.define(version: 20150127033817) do

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "spot_id"
    t.datetime "pubdate"
    t.text     "content",    default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "comments", ["pubdate"], name: "index_comments_on_pubdate"
  add_index "comments", ["spot_id"], name: "index_comments_on_spot_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "media_items", force: :cascade do |t|
    t.string   "title",          default: "", null: false
    t.date     "release_date"
    t.string   "tagline",        default: "", null: false
    t.text     "overview",       default: "", null: false
    t.text     "cast",           default: "", null: false
    t.integer  "tmdb_id"
    t.string   "backdrop_path",  default: "", null: false
    t.string   "poster_path",    default: "", null: false
    t.integer  "season_number"
    t.integer  "episode_number"
    t.integer  "category",       default: 0,  null: false
    t.integer  "parent_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "media_items", ["parent_id"], name: "index_media_items_on_parent_id"
  add_index "media_items", ["release_date"], name: "index_media_items_on_release_date"
  add_index "media_items", ["title"], name: "index_media_items_on_title"
  add_index "media_items", ["tmdb_id"], name: "index_media_items_on_tmdb_id"

  create_table "movies", force: :cascade do |t|
    t.string   "title",         default: "", null: false
    t.date     "release_date"
    t.string   "tagline",       default: "", null: false
    t.text     "overview",      default: "", null: false
    t.integer  "tmdb_id"
    t.string   "backdrop_path", default: "", null: false
    t.string   "poster_path",   default: "", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "movies", ["release_date"], name: "index_movies_on_release_date"
  add_index "movies", ["title"], name: "index_movies_on_title"

  create_table "notifications", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.integer  "category",     default: 0, null: false
    t.integer  "status",       default: 0, null: false
    t.integer  "reference_id"
    t.datetime "pubdate"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "notifications", ["recipient_id"], name: "index_notifications_on_recipient_id"
  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id"

  create_table "recommendations", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.integer  "media_item_id"
    t.datetime "pubdate"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "spot_id"
  end

  add_index "recommendations", ["media_item_id"], name: "index_recommendations_on_media_item_id"
  add_index "recommendations", ["recipient_id"], name: "index_recommendations_on_recipient_id"
  add_index "recommendations", ["sender_id"], name: "index_recommendations_on_sender_id"
  add_index "recommendations", ["spot_id"], name: "index_recommendations_on_spot_id"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "spots", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_item_id"
    t.text     "review"
    t.integer  "veredict"
    t.datetime "pubdate"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "spots", ["media_item_id"], name: "index_spots_on_media_item_id"
  add_index "spots", ["pubdate"], name: "index_spots_on_pubdate"
  add_index "spots", ["user_id"], name: "index_spots_on_user_id"

  create_table "tag_alongs", force: :cascade do |t|
    t.integer  "tagger_id"
    t.integer  "tagged_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tag_alongs", ["tagged_id"], name: "index_tag_alongs_on_tagged_id"
  add_index "tag_alongs", ["tagger_id", "tagged_id"], name: "index_tag_alongs_on_tagger_id_and_tagged_id", unique: true
  add_index "tag_alongs", ["tagger_id"], name: "index_tag_alongs_on_tagger_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username",               default: "",     null: false
    t.string   "full_name",              default: "",     null: false
    t.string   "avatar_url",             default: "",     null: false
    t.text     "bio",                    default: "",     null: false
    t.string   "role",                   default: "user", null: false
    t.string   "provider",               default: "",     null: false
    t.string   "google_id",              default: "",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "veredicts", force: :cascade do |t|
    t.integer  "spot_id"
    t.integer  "user_id"
    t.datetime "pubdate"
    t.integer  "veredict",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "veredicts", ["spot_id"], name: "index_veredicts_on_spot_id"
  add_index "veredicts", ["user_id"], name: "index_veredicts_on_user_id"

end
