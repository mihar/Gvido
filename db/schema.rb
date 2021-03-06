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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150824041926) do

  create_table "abouts", :force => true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "contact"
  end

  create_table "agreements", :force => true do |t|
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "album_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",          :default => 0
    t.text     "description"
    t.integer  "album_category_id"
    t.date     "taken_at"
  end

  create_table "banners", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "url"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "billing_options", :force => true do |t|
    t.text   "description"
    t.string "short_description"
  end

  create_table "contacts", :force => true do |t|
    t.string   "email"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.text     "experience"
    t.boolean  "processed",  :default => false
  end

  create_table "contacts_instruments", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "instrument_id"
  end

  create_table "contacts_locations", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "location_id"
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "instrument_id"
    t.integer  "mentor_id"
    t.integer  "student_id"
    t.date     "enrollment_date"
    t.date     "cancel_date"
    t.decimal  "total_price",                 :precision => 8, :scale => 2
    t.decimal  "prepayment",                  :precision => 8, :scale => 2, :default => 0.0
    t.integer  "nr_of_lessons"
    t.decimal  "discount",                    :precision => 6, :scale => 4, :default => 0.0
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.boolean  "deleted",                                                   :default => false
    t.decimal  "enrollment_fee",              :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "price_per_lesson",            :precision => 6, :scale => 2, :default => 0.0
    t.date     "prepayment_payment_date"
    t.date     "enrollment_fee_payment_date"
  end

  create_table "expenses", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",      :precision => 10, :scale => 0
    t.integer  "mentor_id"
    t.datetime "incurred_at"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "gigs", :force => true do |t|
    t.string   "title"
    t.string   "venue"
    t.string   "address"
    t.text     "description"
    t.datetime "happening_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gigs_mentors", :id => false, :force => true do |t|
    t.integer "mentor_id"
    t.integer "gig_id"
  end

  create_table "instruments", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.text     "description"
    t.text     "goals"
    t.text     "activities"
    t.text     "introduction"
    t.text     "shop_instructions"
    t.integer  "position",          :default => 0
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "instruments_locations", :id => false, :force => true do |t|
    t.integer "instrument_id"
    t.integer "location_id"
  end

  create_table "instruments_mentors", :id => false, :force => true do |t|
    t.integer "mentor_id"
    t.integer "instrument_id"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "student_id"
    t.string   "monthly_reference"
    t.decimal  "price",                          :precision => 8, :scale => 2, :default => 0.0
    t.date     "payment_date"
    t.boolean  "settled",                                                      :default => false
    t.string   "description"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
    t.string   "payers_name"
    t.string   "payers_address"
    t.string   "recievers_name"
    t.string   "recievers_address"
    t.string   "recievers_post_office_and_city"
    t.string   "payers_post_office_and_city"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
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
    t.integer  "post_office_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.integer  "location_section_id"
    t.string   "subtitle"
    t.text     "about"
    t.string   "uri"
    t.boolean  "gmaps"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "about"
    t.string   "permalink"
    t.integer  "position",                                                :default => 0
    t.string   "facebook"
    t.string   "myspace"
    t.boolean  "public_email",                                            :default => false
    t.boolean  "public_phone",                                            :default => false
    t.boolean  "public_address",                                          :default => false
    t.datetime "last_hours_entry_at"
    t.decimal  "price_per_private_lesson",  :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "public_lesson_coefficient", :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "referent",                                                :default => false
  end

  create_table "monthly_lessons", :force => true do |t|
    t.integer  "mentor_id"
    t.integer  "student_id"
    t.integer  "enrollment_id"
    t.integer  "payment_period_id"
    t.integer  "hours",             :default => 0
    t.date     "date"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "public_lesson",     :default => false
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.string   "youtube"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "expires_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_periods", :force => true do |t|
    t.integer  "enrollment_id"
    t.string   "payment_plan_id"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "discount",          :precision => 7, :scale => 4, :default => 0.0
    t.boolean  "deduct_prepayment",                               :default => false
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.integer  "post_office_id"
    t.string   "place"
    t.string   "mobile"
    t.string   "email"
    t.string   "landline"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "status_id"
    t.text     "notes"
    t.date     "date_of_birth"
    t.string   "reference_number"
    t.integer  "billing_option_id"
    t.integer  "student_id"
    t.string   "type"
    t.integer  "contact_id"
    t.integer  "day_of_birth"
    t.integer  "month_of_birth"
    t.integer  "year_of_birth"
  end

  create_table "photos", :force => true do |t|
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "title"
  end

  create_table "post_offices", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "name"
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
    t.integer  "position",   :default => 0
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.text   "description"
    t.string "short_description"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin",               :default => false
    t.string   "email",                                  :null => false
    t.string   "encrypted_password",                     :null => false
    t.string   "password_salt"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "mentor_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
