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

ActiveRecord::Schema[7.2].define(version: 2026_01_29_152702) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "championship_clubs", force: :cascade do |t|
    t.bigint "championship_id", null: false
    t.bigint "club_id", null: false
    t.integer "position_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id", "club_id"], name: "index_championship_clubs_on_championship_id_and_club_id", unique: true
    t.index ["championship_id"], name: "index_championship_clubs_on_championship_id"
    t.index ["club_id"], name: "index_championship_clubs_on_club_id"
  end

  create_table "championships", force: :cascade do |t|
    t.integer "year", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "favorite_club_id"
    t.index ["active"], name: "index_championships_on_active"
    t.index ["favorite_club_id"], name: "index_championships_on_favorite_club_id"
    t.index ["year"], name: "index_championships_on_year", unique: true
  end

  create_table "club_stadiums", force: :cascade do |t|
    t.bigint "club_id", null: false
    t.bigint "stadium_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id", "stadium_id"], name: "index_club_stadiums_on_club_id_and_stadium_id", unique: true
    t.index ["club_id"], name: "index_club_stadiums_on_club_id"
    t.index ["stadium_id"], name: "index_club_stadiums_on_stadium_id"
  end

  create_table "clubs", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation", limit: 3, null: false
    t.string "primary_color"
    t.boolean "special_club", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "badge_filename"
    t.bigint "primary_stadium_id"
    t.index ["abbreviation"], name: "index_clubs_on_abbreviation", unique: true
    t.index ["name"], name: "index_clubs_on_name", unique: true
    t.index ["primary_stadium_id"], name: "index_clubs_on_primary_stadium_id"
    t.index ["special_club"], name: "index_clubs_on_special_club"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "home_club_id", null: false
    t.bigint "away_club_id", null: false
    t.datetime "scheduled_at", null: false
    t.integer "home_score"
    t.integer "away_score"
    t.boolean "finished", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stadium_id"
    t.index ["away_club_id"], name: "index_matches_on_away_club_id"
    t.index ["finished"], name: "index_matches_on_finished"
    t.index ["home_club_id"], name: "index_matches_on_home_club_id"
    t.index ["round_id", "home_club_id", "away_club_id"], name: "index_matches_on_round_and_clubs", unique: true
    t.index ["round_id"], name: "index_matches_on_round_id"
    t.index ["scheduled_at"], name: "index_matches_on_scheduled_at"
    t.index ["stadium_id"], name: "index_matches_on_stadium_id"
  end

  create_table "overall_standings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "championship_id", null: false
    t.integer "total_points", default: 0
    t.integer "rounds_won", default: 0
    t.integer "exact_scores", default: 0
    t.integer "correct_results", default: 0
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id"], name: "index_overall_standings_on_championship_id"
    t.index ["position"], name: "index_overall_standings_on_position"
    t.index ["user_id", "championship_id"], name: "index_overall_standings_on_user_id_and_championship_id", unique: true
    t.index ["user_id"], name: "index_overall_standings_on_user_id"
  end

  create_table "predictions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "match_id", null: false
    t.integer "home_score", default: 0, null: false
    t.integer "away_score", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "predicted_at"
    t.boolean "locked", default: false
    t.index ["match_id"], name: "index_predictions_on_match_id"
    t.index ["predicted_at"], name: "index_predictions_on_predicted_at"
    t.index ["user_id", "match_id"], name: "index_predictions_on_user_id_and_match_id", unique: true
    t.index ["user_id"], name: "index_predictions_on_user_id"
  end

  create_table "round_scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "round_id", null: false
    t.integer "total_points", default: 0
    t.integer "exact_scores", default: 0
    t.integer "correct_results", default: 0
    t.integer "special_exact_scores", default: 0
    t.integer "special_correct_results", default: 0
    t.integer "position", default: 0
    t.boolean "winner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id", "position"], name: "index_round_scores_on_round_id_and_position"
    t.index ["round_id"], name: "index_round_scores_on_round_id"
    t.index ["user_id", "round_id"], name: "index_round_scores_on_user_id_and_round_id", unique: true
    t.index ["user_id"], name: "index_round_scores_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "championship_id"
    t.index ["championship_id", "number"], name: "index_rounds_on_championship_id_and_number", unique: true
    t.index ["championship_id"], name: "index_rounds_on_championship_id"
    t.index ["number"], name: "index_rounds_on_number", unique: true
  end

  create_table "stadiums", force: :cascade do |t|
    t.string "name", null: false
    t.string "city", null: false
    t.string "state", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stadiums_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "provider"
    t.string "uid"
    t.string "avatar_url"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "championship_clubs", "championships"
  add_foreign_key "championship_clubs", "clubs"
  add_foreign_key "championships", "clubs", column: "favorite_club_id"
  add_foreign_key "club_stadiums", "clubs"
  add_foreign_key "club_stadiums", "stadiums"
  add_foreign_key "clubs", "stadiums", column: "primary_stadium_id"
  add_foreign_key "matches", "clubs", column: "away_club_id"
  add_foreign_key "matches", "clubs", column: "home_club_id"
  add_foreign_key "matches", "rounds"
  add_foreign_key "matches", "stadiums"
  add_foreign_key "overall_standings", "championships"
  add_foreign_key "overall_standings", "users"
  add_foreign_key "predictions", "matches"
  add_foreign_key "predictions", "users"
  add_foreign_key "round_scores", "rounds"
  add_foreign_key "round_scores", "users"
  add_foreign_key "rounds", "championships"
end
