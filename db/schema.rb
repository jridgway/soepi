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

ActiveRecord::Schema.define(:version => 20120113145747) do

  create_table "age_groups", :force => true do |t|
    t.string   "label"
    t.integer  "min"
    t.integer  "max"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "age_groups_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "age_group_id"
  end

  create_table "census_geo_profiles", :force => true do |t|
    t.string  "fileid",      :limit => 6
    t.string  "stusab",      :limit => 4
    t.string  "chariter",    :limit => 4
    t.string  "cifsn",       :limit => 4
    t.string  "logrecno",    :limit => 7
    t.decimal "dpsf0010001",              :precision => 12, :scale => 2
    t.decimal "dpsf0010002",              :precision => 12, :scale => 2
    t.decimal "dpsf0010003",              :precision => 12, :scale => 2
    t.decimal "dpsf0010004",              :precision => 12, :scale => 2
    t.decimal "dpsf0010005",              :precision => 12, :scale => 2
    t.decimal "dpsf0010006",              :precision => 12, :scale => 2
    t.decimal "dpsf0010007",              :precision => 12, :scale => 2
    t.decimal "dpsf0010008",              :precision => 12, :scale => 2
    t.decimal "dpsf0010009",              :precision => 12, :scale => 2
    t.decimal "dpsf0010010",              :precision => 12, :scale => 2
    t.decimal "dpsf0010011",              :precision => 12, :scale => 2
    t.decimal "dpsf0010012",              :precision => 12, :scale => 2
    t.decimal "dpsf0010013",              :precision => 12, :scale => 2
    t.decimal "dpsf0010014",              :precision => 12, :scale => 2
    t.decimal "dpsf0010015",              :precision => 12, :scale => 2
    t.decimal "dpsf0010016",              :precision => 12, :scale => 2
    t.decimal "dpsf0010017",              :precision => 12, :scale => 2
    t.decimal "dpsf0010018",              :precision => 12, :scale => 2
    t.decimal "dpsf0010019",              :precision => 12, :scale => 2
    t.decimal "dpsf0010020",              :precision => 12, :scale => 2
    t.decimal "dpsf0010021",              :precision => 12, :scale => 2
    t.decimal "dpsf0010022",              :precision => 12, :scale => 2
    t.decimal "dpsf0010023",              :precision => 12, :scale => 2
    t.decimal "dpsf0010024",              :precision => 12, :scale => 2
    t.decimal "dpsf0010025",              :precision => 12, :scale => 2
    t.decimal "dpsf0010026",              :precision => 12, :scale => 2
    t.decimal "dpsf0010027",              :precision => 12, :scale => 2
    t.decimal "dpsf0010028",              :precision => 12, :scale => 2
    t.decimal "dpsf0010029",              :precision => 12, :scale => 2
    t.decimal "dpsf0010030",              :precision => 12, :scale => 2
    t.decimal "dpsf0010031",              :precision => 12, :scale => 2
    t.decimal "dpsf0010032",              :precision => 12, :scale => 2
    t.decimal "dpsf0010033",              :precision => 12, :scale => 2
    t.decimal "dpsf0010034",              :precision => 12, :scale => 2
    t.decimal "dpsf0010035",              :precision => 12, :scale => 2
    t.decimal "dpsf0010036",              :precision => 12, :scale => 2
    t.decimal "dpsf0010037",              :precision => 12, :scale => 2
    t.decimal "dpsf0010038",              :precision => 12, :scale => 2
    t.decimal "dpsf0010039",              :precision => 12, :scale => 2
    t.decimal "dpsf0010040",              :precision => 12, :scale => 2
    t.decimal "dpsf0010041",              :precision => 12, :scale => 2
    t.decimal "dpsf0010042",              :precision => 12, :scale => 2
    t.decimal "dpsf0010043",              :precision => 12, :scale => 2
    t.decimal "dpsf0010044",              :precision => 12, :scale => 2
    t.decimal "dpsf0010045",              :precision => 12, :scale => 2
    t.decimal "dpsf0010046",              :precision => 12, :scale => 2
    t.decimal "dpsf0010047",              :precision => 12, :scale => 2
    t.decimal "dpsf0010048",              :precision => 12, :scale => 2
    t.decimal "dpsf0010049",              :precision => 12, :scale => 2
    t.decimal "dpsf0010050",              :precision => 12, :scale => 2
    t.decimal "dpsf0010051",              :precision => 12, :scale => 2
    t.decimal "dpsf0010052",              :precision => 12, :scale => 2
    t.decimal "dpsf0010053",              :precision => 12, :scale => 2
    t.decimal "dpsf0010054",              :precision => 12, :scale => 2
    t.decimal "dpsf0010055",              :precision => 12, :scale => 2
    t.decimal "dpsf0010056",              :precision => 12, :scale => 2
    t.decimal "dpsf0010057",              :precision => 12, :scale => 2
    t.decimal "dpsf0020001",              :precision => 12, :scale => 2
    t.decimal "dpsf0020002",              :precision => 12, :scale => 2
    t.decimal "dpsf0020003",              :precision => 12, :scale => 2
    t.decimal "dpsf0030001",              :precision => 12, :scale => 2
    t.decimal "dpsf0030002",              :precision => 12, :scale => 2
    t.decimal "dpsf0030003",              :precision => 12, :scale => 2
    t.decimal "dpsf0040001",              :precision => 12, :scale => 2
    t.decimal "dpsf0040002",              :precision => 12, :scale => 2
    t.decimal "dpsf0040003",              :precision => 12, :scale => 2
    t.decimal "dpsf0050001",              :precision => 12, :scale => 2
    t.decimal "dpsf0050002",              :precision => 12, :scale => 2
    t.decimal "dpsf0050003",              :precision => 12, :scale => 2
    t.decimal "dpsf0060001",              :precision => 12, :scale => 2
    t.decimal "dpsf0060002",              :precision => 12, :scale => 2
    t.decimal "dpsf0060003",              :precision => 12, :scale => 2
    t.decimal "dpsf0070001",              :precision => 12, :scale => 2
    t.decimal "dpsf0070002",              :precision => 12, :scale => 2
    t.decimal "dpsf0070003",              :precision => 12, :scale => 2
    t.decimal "dpsf0080001",              :precision => 12, :scale => 2
    t.decimal "dpsf0080002",              :precision => 12, :scale => 2
    t.decimal "dpsf0080003",              :precision => 12, :scale => 2
    t.decimal "dpsf0080004",              :precision => 12, :scale => 2
    t.decimal "dpsf0080005",              :precision => 12, :scale => 2
    t.decimal "dpsf0080006",              :precision => 12, :scale => 2
    t.decimal "dpsf0080007",              :precision => 12, :scale => 2
    t.decimal "dpsf0080008",              :precision => 12, :scale => 2
    t.decimal "dpsf0080009",              :precision => 12, :scale => 2
    t.decimal "dpsf0080010",              :precision => 12, :scale => 2
    t.decimal "dpsf0080011",              :precision => 12, :scale => 2
    t.decimal "dpsf0080012",              :precision => 12, :scale => 2
    t.decimal "dpsf0080013",              :precision => 12, :scale => 2
    t.decimal "dpsf0080014",              :precision => 12, :scale => 2
    t.decimal "dpsf0080015",              :precision => 12, :scale => 2
    t.decimal "dpsf0080016",              :precision => 12, :scale => 2
    t.decimal "dpsf0080017",              :precision => 12, :scale => 2
    t.decimal "dpsf0080018",              :precision => 12, :scale => 2
    t.decimal "dpsf0080019",              :precision => 12, :scale => 2
    t.decimal "dpsf0080020",              :precision => 12, :scale => 2
    t.decimal "dpsf0080021",              :precision => 12, :scale => 2
    t.decimal "dpsf0080022",              :precision => 12, :scale => 2
    t.decimal "dpsf0080023",              :precision => 12, :scale => 2
    t.decimal "dpsf0080024",              :precision => 12, :scale => 2
    t.decimal "dpsf0090001",              :precision => 12, :scale => 2
    t.decimal "dpsf0090002",              :precision => 12, :scale => 2
    t.decimal "dpsf0090003",              :precision => 12, :scale => 2
    t.decimal "dpsf0090004",              :precision => 12, :scale => 2
    t.decimal "dpsf0090005",              :precision => 12, :scale => 2
    t.decimal "dpsf0090006",              :precision => 12, :scale => 2
    t.decimal "dpsf0100001",              :precision => 12, :scale => 2
    t.decimal "dpsf0100002",              :precision => 12, :scale => 2
    t.decimal "dpsf0100003",              :precision => 12, :scale => 2
    t.decimal "dpsf0100004",              :precision => 12, :scale => 2
    t.decimal "dpsf0100005",              :precision => 12, :scale => 2
    t.decimal "dpsf0100006",              :precision => 12, :scale => 2
    t.decimal "dpsf0100007",              :precision => 12, :scale => 2
    t.decimal "dpsf0110001",              :precision => 12, :scale => 2
    t.decimal "dpsf0110002",              :precision => 12, :scale => 2
    t.decimal "dpsf0110003",              :precision => 12, :scale => 2
    t.decimal "dpsf0110004",              :precision => 12, :scale => 2
    t.decimal "dpsf0110005",              :precision => 12, :scale => 2
    t.decimal "dpsf0110006",              :precision => 12, :scale => 2
    t.decimal "dpsf0110007",              :precision => 12, :scale => 2
    t.decimal "dpsf0110008",              :precision => 12, :scale => 2
    t.decimal "dpsf0110009",              :precision => 12, :scale => 2
    t.decimal "dpsf0110010",              :precision => 12, :scale => 2
    t.decimal "dpsf0110011",              :precision => 12, :scale => 2
    t.decimal "dpsf0110012",              :precision => 12, :scale => 2
    t.decimal "dpsf0110013",              :precision => 12, :scale => 2
    t.decimal "dpsf0110014",              :precision => 12, :scale => 2
    t.decimal "dpsf0110015",              :precision => 12, :scale => 2
    t.decimal "dpsf0110016",              :precision => 12, :scale => 2
    t.decimal "dpsf0110017",              :precision => 12, :scale => 2
    t.decimal "dpsf0120001",              :precision => 12, :scale => 2
    t.decimal "dpsf0120002",              :precision => 12, :scale => 2
    t.decimal "dpsf0120003",              :precision => 12, :scale => 2
    t.decimal "dpsf0120004",              :precision => 12, :scale => 2
    t.decimal "dpsf0120005",              :precision => 12, :scale => 2
    t.decimal "dpsf0120006",              :precision => 12, :scale => 2
    t.decimal "dpsf0120007",              :precision => 12, :scale => 2
    t.decimal "dpsf0120008",              :precision => 12, :scale => 2
    t.decimal "dpsf0120009",              :precision => 12, :scale => 2
    t.decimal "dpsf0120010",              :precision => 12, :scale => 2
    t.decimal "dpsf0120011",              :precision => 12, :scale => 2
    t.decimal "dpsf0120012",              :precision => 12, :scale => 2
    t.decimal "dpsf0120013",              :precision => 12, :scale => 2
    t.decimal "dpsf0120014",              :precision => 12, :scale => 2
    t.decimal "dpsf0120015",              :precision => 12, :scale => 2
    t.decimal "dpsf0120016",              :precision => 12, :scale => 2
    t.decimal "dpsf0120017",              :precision => 12, :scale => 2
    t.decimal "dpsf0120018",              :precision => 12, :scale => 2
    t.decimal "dpsf0120019",              :precision => 12, :scale => 2
    t.decimal "dpsf0120020",              :precision => 12, :scale => 2
    t.decimal "dpsf0130001",              :precision => 12, :scale => 2
    t.decimal "dpsf0130002",              :precision => 12, :scale => 2
    t.decimal "dpsf0130003",              :precision => 12, :scale => 2
    t.decimal "dpsf0130004",              :precision => 12, :scale => 2
    t.decimal "dpsf0130005",              :precision => 12, :scale => 2
    t.decimal "dpsf0130006",              :precision => 12, :scale => 2
    t.decimal "dpsf0130007",              :precision => 12, :scale => 2
    t.decimal "dpsf0130008",              :precision => 12, :scale => 2
    t.decimal "dpsf0130009",              :precision => 12, :scale => 2
    t.decimal "dpsf0130010",              :precision => 12, :scale => 2
    t.decimal "dpsf0130011",              :precision => 12, :scale => 2
    t.decimal "dpsf0130012",              :precision => 12, :scale => 2
    t.decimal "dpsf0130013",              :precision => 12, :scale => 2
    t.decimal "dpsf0130014",              :precision => 12, :scale => 2
    t.decimal "dpsf0130015",              :precision => 12, :scale => 2
    t.decimal "dpsf0140001",              :precision => 12, :scale => 2
    t.decimal "dpsf0150001",              :precision => 12, :scale => 2
    t.decimal "dpsf0160001",              :precision => 12, :scale => 2
    t.decimal "dpsf0170001",              :precision => 12, :scale => 2
    t.decimal "dpsf0180001",              :precision => 12, :scale => 2
    t.decimal "dpsf0180002",              :precision => 12, :scale => 2
    t.decimal "dpsf0180003",              :precision => 12, :scale => 2
    t.decimal "dpsf0180004",              :precision => 12, :scale => 2
    t.decimal "dpsf0180005",              :precision => 12, :scale => 2
    t.decimal "dpsf0180006",              :precision => 12, :scale => 2
    t.decimal "dpsf0180007",              :precision => 12, :scale => 2
    t.decimal "dpsf0180008",              :precision => 12, :scale => 2
    t.decimal "dpsf0180009",              :precision => 12, :scale => 2
    t.decimal "dpsf0190001",              :precision => 12, :scale => 2
    t.decimal "dpsf0200001",              :precision => 12, :scale => 2
    t.decimal "dpsf0210001",              :precision => 12, :scale => 2
    t.decimal "dpsf0210002",              :precision => 12, :scale => 2
    t.decimal "dpsf0210003",              :precision => 12, :scale => 2
    t.decimal "dpsf0220001",              :precision => 12, :scale => 2
    t.decimal "dpsf0220002",              :precision => 12, :scale => 2
    t.decimal "dpsf0230001",              :precision => 12, :scale => 2
    t.decimal "dpsf0230002",              :precision => 12, :scale => 2
  end

  create_table "census_geos", :force => true do |t|
    t.integer "census_id",               :null => false
    t.string  "fileid",    :limit => 6
    t.string  "stusab",    :limit => 2
    t.string  "sumlev",    :limit => 3
    t.string  "geocomp",   :limit => 2
    t.string  "chariter",  :limit => 3
    t.string  "cifsn",     :limit => 2
    t.string  "logrecno",  :limit => 3
    t.string  "region",    :limit => 1
    t.string  "division",  :limit => 1
    t.string  "state",     :limit => 2
    t.string  "county",    :limit => 3
    t.string  "countycc",  :limit => 2
    t.string  "countysc",  :limit => 2
    t.string  "cousub",    :limit => 3
    t.string  "cousubcc",  :limit => 2
    t.string  "cousubsc",  :limit => 2
    t.string  "place",     :limit => 3
    t.string  "placecc",   :limit => 2
    t.string  "placesc",   :limit => 2
    t.string  "tract",     :limit => 6
    t.string  "blkgrp",    :limit => 1
    t.string  "block",     :limit => 4
    t.string  "iuc",       :limit => 2
    t.string  "concit",    :limit => 3
    t.string  "concitcc",  :limit => 2
    t.string  "concitsc",  :limit => 2
    t.string  "aianhh",    :limit => 4
    t.string  "aianhhfp",  :limit => 3
    t.string  "aianhhcc",  :limit => 2
    t.string  "aihhtli",   :limit => 1
    t.string  "aitsce",    :limit => 3
    t.string  "aits",      :limit => 3
    t.string  "aitscc",    :limit => 2
    t.string  "ttract",    :limit => 6
    t.string  "tblkgrp",   :limit => 1
    t.string  "anrc",      :limit => 3
    t.string  "anrccc",    :limit => 2
    t.string  "cbsa",      :limit => 3
    t.string  "cbsasc",    :limit => 2
    t.string  "metdiv",    :limit => 3
    t.string  "csa",       :limit => 3
    t.string  "necta",     :limit => 3
    t.string  "nectasc",   :limit => 2
    t.string  "nectadiv",  :limit => 3
    t.string  "cnecta",    :limit => 3
    t.string  "cbsapci",   :limit => 1
    t.string  "nectapci",  :limit => 1
    t.string  "ua",        :limit => 3
    t.string  "uasc",      :limit => 2
    t.string  "uatype",    :limit => 1
    t.string  "ur",        :limit => 1
    t.string  "cd",        :limit => 2
    t.string  "sldu",      :limit => 3
    t.string  "sldl",      :limit => 3
    t.string  "vtd",       :limit => 6
    t.string  "vtdi",      :limit => 1
    t.string  "reserve2",  :limit => 3
    t.string  "zcta5",     :limit => 3
    t.string  "submcd",    :limit => 3
    t.string  "submcdcc",  :limit => 2
    t.string  "sdelm",     :limit => 3
    t.string  "sdsec",     :limit => 3
    t.string  "sduni",     :limit => 3
    t.string  "arealand",  :limit => 14
    t.string  "areawatr",  :limit => 14
    t.string  "name",      :limit => 90
    t.string  "funcstat",  :limit => 1
    t.string  "gcuni",     :limit => 1
    t.string  "pop100",    :limit => 9
    t.string  "hu100",     :limit => 9
    t.string  "intptlat",  :limit => 11
    t.string  "intptlon",  :limit => 12
    t.string  "lsadc",     :limit => 2
    t.string  "partflag",  :limit => 1
    t.string  "reserve3",  :limit => 6
    t.string  "uga",       :limit => 3
    t.string  "statens",   :limit => 8
    t.string  "countyns",  :limit => 8
    t.string  "cousubns",  :limit => 8
    t.string  "placens",   :limit => 8
    t.string  "concitns",  :limit => 8
    t.string  "aianhhns",  :limit => 8
    t.string  "aitsns",    :limit => 8
    t.string  "anrcns",    :limit => 8
    t.string  "submcdns",  :limit => 8
    t.string  "cd113",     :limit => 2
    t.string  "cd114",     :limit => 2
    t.string  "cd115",     :limit => 2
    t.string  "sldu2",     :limit => 3
    t.string  "sldu3",     :limit => 3
    t.string  "sldu4",     :limit => 3
    t.string  "sldl2",     :limit => 3
    t.string  "sldl3",     :limit => 3
    t.string  "sldl4",     :limit => 3
    t.string  "aianhhsc",  :limit => 2
    t.string  "csasc",     :limit => 2
    t.string  "cnectasc",  :limit => 2
    t.string  "memi",      :limit => 1
    t.string  "nmemi",     :limit => 1
    t.string  "puma",      :limit => 3
    t.string  "reserved",  :limit => 18
  end

  create_table "censuses", :force => true do |t|
    t.integer "year", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "educations", :force => true do |t|
    t.string   "label"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "education_id"
  end

  create_table "ethnicities", :force => true do |t|
    t.string   "label"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ethnicities_members", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "ethnicity_id"
  end

  create_table "ethnicities_participant_surveys", :id => false, :force => true do |t|
    t.integer "participant_survey_id"
    t.integer "ethnicity_id"
  end

  create_table "ethnicities_participants", :id => false, :force => true do |t|
    t.integer "participant_id"
    t.integer "ethnicity_id"
  end

  create_table "ethnicities_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "ethnicity_id"
  end

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",   :null => false
    t.string   "followable_type", :null => false
    t.integer  "follower_id",     :null => false
    t.string   "follower_type",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "genders", :force => true do |t|
    t.string   "label"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "gender_id"
  end

  create_table "member_credit_transactions", :force => true do |t|
    t.integer  "credits"
    t.integer  "member_id",  :null => false
    t.string   "reason",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_ethnicities", :force => true do |t|
    t.integer  "member_id"
    t.integer  "ethnicity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_races", :force => true do |t|
    t.integer  "member_id"
    t.integer  "race_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_statuses", :force => true do |t|
    t.text     "body"
    t.integer  "repost_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_statuses_members", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "member_status_id"
  end

  create_table "member_surveys", :force => true do |t|
    t.integer "member_id"
    t.integer "survey_id"
  end

  add_index "member_surveys", ["id"], :name => "index_member_surveys_on_id", :unique => true
  add_index "member_surveys", ["member_id"], :name => "index_member_surveys_on_member_id"
  add_index "member_surveys", ["survey_id"], :name => "index_member_surveys_on_survey_id"

  create_table "member_tokens", :force => true do |t|
    t.integer  "member_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "member_tokens", ["member_id"], :name => "index_member_tokens_on_member_id"

  create_table "members", :force => true do |t|
    t.string   "password_salt"
    t.string   "email"
    t.string   "encrypted_password",            :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.integer  "failed_attempts",                              :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "nickname"
    t.string   "pic"
    t.string   "pic_uid"
    t.string   "pic_mime_type"
    t.string   "pic_name"
    t.integer  "pic_size"
    t.integer  "pic_width"
    t.integer  "pic_height"
    t.string   "pic_image_uid"
    t.string   "pic_image_ext"
    t.string   "phone"
    t.string   "timezone"
    t.string   "language"
    t.boolean  "informed_consent",                             :default => false
    t.boolean  "terms_of_use",                                 :default => false
    t.boolean  "subscription_notifications",                   :default => true
    t.boolean  "subscription_messages",                        :default => true
    t.boolean  "subscription_news",                            :default => true
    t.integer  "year_registered"
    t.boolean  "admin",                                        :default => false
    t.boolean  "subscription_charts",                          :default => true
    t.boolean  "privacy_dont_use_my_gravatar",                 :default => false
    t.boolean  "privacy_dont_list_me",                         :default => false
    t.string   "slug"
    t.boolean  "subscription_weekly_summaries",                :default => true
    t.integer  "credits",                                      :default => 10
    t.string   "ec2_instance_id"
    t.boolean  "booting_ec2_instance",                         :default => false
    t.datetime "ec2_last_accessed_at"
  end

  add_index "members", ["confirmation_token"], :name => "index_members_on_confirmation_token", :unique => true
  add_index "members", ["email"], :name => "index_members_on_email", :unique => true
  add_index "members", ["id"], :name => "index_members_on_id", :unique => true
  add_index "members", ["nickname"], :name => "index_members_on_nickname", :unique => true
  add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true
  add_index "members", ["slug"], :name => "index_members_on_slug"
  add_index "members", ["unlock_token"], :name => "index_members_on_unlock_token", :unique => true

  create_table "members_races", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "race_id"
  end

  create_table "members_surveys", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "survey_id"
  end

  create_table "message_members", :force => true do |t|
    t.integer  "member_id"
    t.integer  "message_id"
    t.boolean  "seen"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "member_id"
    t.text     "body"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.string   "message"
    t.integer  "member_id"
    t.boolean  "seen",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occupations", :force => true do |t|
    t.string   "label"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occupations_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "occupation_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "title",                                 :null => false
    t.text     "body"
    t.text     "css"
    t.text     "javascript"
    t.string   "browser_title"
    t.string   "custom_title"
    t.boolean  "use_custom_title", :default => false
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "redirect_url"
    t.string   "state",            :default => "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "raw",              :default => false
    t.string   "author_nickname"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "participant_responses", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "question_id"
    t.integer  "numeric_response"
    t.datetime "datetime_response"
    t.text     "text_response"
    t.date     "created_at"
    t.integer  "single_choice_id"
    t.integer  "participant_survey_id"
  end

  add_index "participant_responses", ["id"], :name => "index_participant_responses_on_id", :unique => true
  add_index "participant_responses", ["participant_id", "question_id"], :name => "index_participant_responses_on_participant_id_and_question_id", :unique => true
  add_index "participant_responses", ["participant_id"], :name => "index_participant_responses_on_participant_id"
  add_index "participant_responses", ["question_id"], :name => "index_participant_responses_on_question_id"

  create_table "participant_responses_survey_question_choices", :id => false, :force => true do |t|
    t.integer "participant_response_id"
    t.integer "survey_question_choice_id"
  end

  create_table "participant_surveys", :force => true do |t|
    t.integer "participant_id"
    t.integer "survey_id"
    t.integer "gender_id"
    t.integer "education_id"
    t.string  "city"
    t.string  "state"
    t.string  "postal_code"
    t.string  "country"
    t.date    "created_at"
    t.integer "next_question_id"
    t.boolean "complete",         :default => false
    t.integer "age_group_id"
    t.integer "region_id"
    t.float   "lat"
    t.float   "lng"
    t.float   "weight",           :default => 1.0
  end

  add_index "participant_surveys", ["id"], :name => "index_participant_surveys_on_id", :unique => true
  add_index "participant_surveys", ["participant_id", "survey_id"], :name => "index_participant_surveys_on_participant_id_and_survey_id", :unique => true
  add_index "participant_surveys", ["participant_id"], :name => "index_participant_surveys_on_participant_id"
  add_index "participant_surveys", ["survey_id"], :name => "index_participant_surveys_on_survey_id"

  create_table "participant_surveys_races", :id => false, :force => true do |t|
    t.integer "participant_survey_id"
    t.integer "race_id"
  end

  create_table "participants", :force => true do |t|
    t.string  "anonymous_key"
    t.integer "gender_id"
    t.integer "education_id"
    t.date    "birthmonth"
    t.string  "city"
    t.string  "state"
    t.string  "postal_code"
    t.string  "country"
    t.float   "lat"
    t.float   "lng"
  end

  add_index "participants", ["anonymous_key"], :name => "index_participants_on_anonymous_key", :unique => true
  add_index "participants", ["id"], :name => "index_participants_on_id", :unique => true

  create_table "participants_races", :id => false, :force => true do |t|
    t.integer "participant_id"
    t.integer "race_id"
  end

  create_table "parts", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.string   "url_regex"
    t.text     "css"
    t.text     "javascript"
    t.datetime "show_at"
    t.datetime "hide_at"
    t.string   "state",      :default => "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "raw",        :default => false
  end

  create_table "races", :force => true do |t|
    t.string   "label"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "race_id"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month"
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "regions", :force => true do |t|
    t.string   "label"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "region_id"
  end

  create_table "report_plots", :force => true do |t|
    t.integer  "report_id",      :null => false
    t.text     "description"
    t.integer  "position"
    t.string   "plot"
    t.string   "plot_uid"
    t.string   "plot_mime_type"
    t.string   "plot_name"
    t.integer  "plot_size"
    t.integer  "plot_width"
    t.integer  "plot_height"
    t.string   "plot_image_uid"
    t.string   "plot_image_ext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.integer  "member_id",                             :null => false
    t.string   "title",                                 :null => false
    t.text     "introduction"
    t.string   "state",          :default => "pending"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "code"
    t.text     "output"
    t.text     "conclusion"
    t.integer  "forked_from_id"
  end

  add_index "reports", ["slug"], :name => "index_reports_on_slug", :unique => true

  create_table "reports_surveys", :id => false, :force => true do |t|
    t.integer "report_id"
    t.integer "survey_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.string   "content_type", :default => "Plain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["name"], :name => "index_settings_on_name", :unique => true

  create_table "survey_downloads", :force => true do |t|
    t.integer  "survey_id",       :null => false
    t.string   "title"
    t.string   "dtype"
    t.integer  "position"
    t.string   "asset"
    t.string   "asset_uid"
    t.string   "asset_mime_type"
    t.string   "asset_name"
    t.integer  "asset_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
  end

  create_table "survey_question_choices", :force => true do |t|
    t.integer  "survey_question_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "value"
  end

  add_index "survey_question_choices", ["id"], :name => "index_survey_question_choices_on_id", :unique => true
  add_index "survey_question_choices", ["survey_question_id"], :name => "index_survey_question_choices_on_question_id"

  create_table "survey_questions", :force => true do |t|
    t.integer  "survey_id"
    t.text     "body"
    t.string   "qtype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "required",                  :default => true
    t.integer  "survey_question_choice_id"
    t.string   "label"
  end

  add_index "survey_questions", ["id"], :name => "index_survey_questions_on_id", :unique => true
  add_index "survey_questions", ["survey_id"], :name => "index_survey_questions_on_survey_id"

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "member_id"
    t.boolean  "anonymous"
    t.datetime "published_at"
    t.datetime "closed_at"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "organization",             :default => false
    t.string   "organization_name"
    t.string   "organization_phone"
    t.string   "organization_email"
    t.text     "purpose_of_survey"
    t.text     "uses_of_results"
    t.integer  "time_required_in_minutes"
    t.boolean  "cohort",                   :default => false
    t.float    "cohort_interval_in_days"
    t.float    "cohort_range_in_days"
    t.boolean  "irb",                      :default => false
    t.string   "irb_name"
    t.string   "irb_phone"
    t.string   "irb_email"
    t.integer  "forked_from_id"
    t.string   "slug"
    t.datetime "review_completed_at"
  end

  add_index "surveys", ["id"], :name => "index_surveys_on_id", :unique => true
  add_index "surveys", ["member_id"], :name => "index_surveys_on_member_id"
  add_index "surveys", ["slug"], :name => "index_surveys_on_slug"

  create_table "surveys_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "survey_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
    t.string "slug"
  end

  add_index "tags", ["slug"], :name => "index_tags_on_slug"

  create_table "target_age_groups", :force => true do |t|
    t.integer  "target_id"
    t.integer  "age_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_educations", :force => true do |t|
    t.integer  "target_id"
    t.integer  "education_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_ethnicities", :force => true do |t|
    t.integer  "target_id"
    t.integer  "ethnicity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_genders", :force => true do |t|
    t.integer  "target_id"
    t.integer  "gender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_occupations", :force => true do |t|
    t.integer  "target_id"
    t.integer  "occupation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_races", :force => true do |t|
    t.integer  "target_id"
    t.integer  "race_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_surveys", :force => true do |t|
    t.integer  "target_id"
    t.integer  "survey_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "targets", :force => true do |t|
    t.boolean  "target_by_location",  :default => false
    t.string   "city"
    t.string   "postal_code"
    t.string   "country"
    t.float    "radius"
    t.float    "lat"
    t.float    "lng"
    t.string   "approximate_address"
    t.boolean  "target_by_age_group", :default => false
    t.boolean  "target_by_gender",    :default => false
    t.boolean  "target_by_education", :default => false
    t.boolean  "target_by_ethnicity", :default => false
    t.boolean  "target_by_race",      :default => false
    t.boolean  "target_by_survey",    :default => false
    t.integer  "targetable_id"
    t.string   "targetable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "location_type",       :default => "address"
  end

end
