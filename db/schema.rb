# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100420092914) do

  create_table "annotations", :force => true do |t|
    t.integer  "start_time_ms"
    t.integer  "end_time_ms"
    t.string   "label"
    t.text     "comments"
    t.integer  "user_id"
    t.integer  "recording_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "call_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calls", :force => true do |t|
    t.string   "matriline"
    t.string   "notes"
    t.string   "audio"
    t.string   "image"
    t.integer  "call_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classifier_annotations", :force => true do |t|
    t.integer  "classifier_id"
    t.integer  "annotation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classifiers", :force => true do |t|
    t.string   "name"
    t.text     "mpl"
    t.text     "arff"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidences", :force => true do |t|
    t.date     "date"
    t.string   "identification"
    t.string   "acoustic_visual"
    t.string   "location"
    t.string   "east_js"
    t.string   "qcs"
    t.string   "observer"
    t.string   "system_info"
    t.string   "effort"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.integer  "state"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labbook_page_recordings", :force => true do |t|
    t.integer  "labbook_page_id"
    t.integer  "recording_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labbook_pages", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "page"
    t.string   "image_file_path"
    t.string   "medium_image_file_path"
    t.string   "small_image_file_path"
    t.string   "thumbnail_image_file_path"
    t.text     "page_text"
    t.integer  "labbook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labbooks", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "pdf_file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maps", :force => true do |t|
    t.date     "date"
    t.string   "image_file_path"
    t.string   "medium_image_file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prediction_annotations", :force => true do |t|
    t.integer  "prediction_id"
    t.integer  "annotation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "predictions", :force => true do |t|
    t.text     "data",         :limit => 16777215
    t.string   "name"
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "recording_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recording_comments", :force => true do |t|
    t.text     "text"
    t.integer  "recording_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recording_start_times", :force => true do |t|
    t.datetime "start_time"
    t.integer  "recording_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recordings", :force => true do |t|
    t.string   "name"
    t.string   "tape"
    t.string   "side"
    t.integer  "year"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "length_ms"
    t.string   "wav_audio_file_path"
    t.string   "mp3_audio_file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recordings", ["year"], :name => "index_recordings_on_year"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "admin"
    t.boolean  "can_annotate"
    t.boolean  "can_set_recording_time"
    t.boolean  "can_set_labbook_page"
    t.string   "mediaserver_url"
    t.boolean  "mediaserver_active"
  end

  create_table "visualizations", :force => true do |t|
    t.string   "name"
    t.string   "params"
    t.string   "file_path"
    t.integer  "recording_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "years", :force => true do |t|
    t.integer  "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
