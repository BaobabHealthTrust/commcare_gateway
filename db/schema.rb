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

ActiveRecord::Schema.define(:version => 20131018121335) do

  create_table "people", :force => true do |t|
    t.string   "case_id"
    t.string   "case_type"
    t.string   "name"
    t.string   "external_id"
    t.string   "owner_id"
    t.date     "date_modified"
    t.string   "given_name"
    t.string   "middle_name"
    t.string   "family_name_prefix"
    t.string   "family_name"
    t.string   "family_name2"
    t.string   "gender"
    t.date     "birthdate"
    t.integer  "birthdate_estimated"
    t.integer  "dead"
    t.date     "death_date"
    t.string   "cause_of_death"
    t.string   "national_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "city_village"
    t.string   "state_province"
    t.string   "postal_code"
    t.string   "country"
    t.string   "county_district"
    t.string   "neighborhood_cell"
    t.string   "region"
    t.string   "subregion"
    t.string   "township_division"
    t.integer  "sync_with_cchq"
    t.integer  "mapped_to_cchq"
    t.integer  "cchq_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
