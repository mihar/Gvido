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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110223171325) do

  create_table "abouts", :force => true do |t|
    t.text     "text"
    t.text     "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "album_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.integer  "position"
    t.text     "description"
    t.integer  "album_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "email"
    t.text     "text"
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "experience"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts_instruments", :id => false, :force => true do |t|
    t.integer "instrument_id"
    t.integer "contact_id"
  end

  create_table "contacts_locations", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "location_id"
  end

  create_table "gigs", :force => true do |t|
    t.string   "title"
    t.string   "venue"
    t.string   "address"
    t.text     "description"
    t.datetime "when"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gigs_mentors", :id => false, :force => true do |t|
    t.integer "gig_id"
    t.integer "mentor_id"
  end

  create_table "instruments", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "description"
    t.text     "goals"
    t.text     "activities"
    t.text     "introduction"
    t.text     "shop_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instruments_locations", :id => false, :force => true do |t|
    t.integer "instrument_id"
    t.integer "location_id"
  end

  create_table "instruments_mentors", :id => false, :force => true do |t|
    t.integer "instrument_id"
    t.integer "mentor_id"
  end

  create_table "link_categories", :force => true do |t|
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "title"
    t.string   "uri"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_sections", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "title"
    t.string   "address"
    t.string   "city"
    t.integer  "zip"
    t.float    "lat"
    t.float    "lng"
    t.integer  "location_section_id"
    t.string   "subtitle"
    t.text     "about"
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations_mentors", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "mentor_id"
  end

  create_table "mentors", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "about"
    t.string   "permalink"
    t.integer  "position"
    t.string   "facebook"
    t.string   "myspace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.string   "youtube"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", :force => true do |t|
    t.string   "title"
    t.string   "body"
    t.datetime "expires_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.integer  "post_id"
    t.string   "place"
    t.string   "mobile"
    t.string   "email"
    t.string   "landline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personal_relations", :force => true do |t|
    t.integer  "person_id"
    t.integer  "related_person_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "album_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.text     "text"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "references", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shop_advices", :force => true do |t|
    t.string   "url"
    t.text     "description"
    t.integer  "instrument_id"
    t.string   "photo_file_name"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
