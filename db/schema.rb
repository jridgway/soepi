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

ActiveRecord::Schema.define(:version => 20111031220437) do

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

  create_table "charts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "member_id"
    t.boolean  "anonymous"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "charts", ["id"], :name => "index_charts_on_id", :unique => true
  add_index "charts", ["member_id"], :name => "index_charts_on_member_id"
  add_index "charts", ["slug"], :name => "index_charts_on_slug"

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
    t.string   "encrypted_password",           :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.integer  "failed_attempts",                             :default => 0
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
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.string   "timezone"
    t.string   "language"
    t.date     "birthmonth"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "informed_consent",                            :default => false
    t.boolean  "terms_of_use",                                :default => false
    t.boolean  "subscription_notifications",                  :default => true
    t.boolean  "subscription_messages",                       :default => true
    t.boolean  "subscription_news",                           :default => true
    t.integer  "year_registered"
    t.boolean  "admin",                                       :default => false
    t.integer  "gender_id"
    t.integer  "occupation_id"
    t.integer  "education_id"
    t.boolean  "subscription_charts",                         :default => true
    t.boolean  "privacy_dont_use_my_gravatar",                :default => false
    t.boolean  "privacy_dont_list_me",                        :default => false
    t.boolean  "privacy_dont_show_location",                  :default => false
    t.string   "slug"
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
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.string   "redirect_url"
    t.string   "state",            :default => "draft"
    t.datetime "show_at"
    t.datetime "hide_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "markup_type"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "participant_responses", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "question_id"
    t.integer  "question_version"
    t.integer  "numeric_response"
    t.datetime "datetime_response"
    t.text     "text_response"
    t.date     "created_at"
    t.integer  "single_choice_id"
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
    t.integer "survey_version"
    t.date    "birthmonth"
    t.integer "gender_id"
    t.integer "occupation_id"
    t.integer "education_id"
    t.string  "city"
    t.string  "region"
    t.string  "postal_code"
    t.string  "country"
    t.date    "created_at"
    t.integer "next_question_id"
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
    t.string "anonymous_key"
  end

  add_index "participants", ["anonymous_key"], :name => "index_participants_on_anonymous_key", :unique => true
  add_index "participants", ["id"], :name => "index_participants_on_id", :unique => true

  create_table "parts", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.string   "url_regex"
    t.text     "css"
    t.text     "javascript"
    t.datetime "show_at"
    t.datetime "hide_at"
    t.string   "state",       :default => "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "markup_type"
  end

  create_table "petitioners", :force => true do |t|
    t.integer  "petition_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "petitions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "promise"
    t.integer  "member_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "petitions", ["id"], :name => "index_petitions_on_id", :unique => true
  add_index "petitions", ["member_id"], :name => "index_petitions_on_member_id"
  add_index "petitions", ["slug"], :name => "index_petitions_on_slug"

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
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.string   "content_type", :default => "Plain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["name"], :name => "index_settings_on_name", :unique => true

  create_table "slides", :force => true do |t|
    t.string   "description"
    t.integer  "position"
    t.datetime "publish_at",    :default => '2011-10-31 20:49:21'
    t.datetime "expires_at"
    t.string   "img"
    t.string   "img_uid"
    t.string   "img_mime_type"
    t.string   "img_name"
    t.integer  "img_size"
    t.integer  "img_width"
    t.integer  "img_height"
    t.string   "img_image_uid"
    t.string   "img_image_ext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
    t.string   "locale"
  end

  add_index "slugs", ["locale"], :name => "index_slugs_on_locale"
  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "survey_question_choices", :force => true do |t|
    t.integer  "survey_question_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
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
  end

  add_index "survey_questions", ["id"], :name => "index_survey_questions_on_id", :unique => true
  add_index "survey_questions", ["survey_id"], :name => "index_survey_questions_on_survey_id"

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "member_id"
    t.boolean  "anonymous"
    t.integer  "minimum_completes_needed"
    t.integer  "maximum_completes_needed"
    t.datetime "closes_soft_at"
    t.datetime "closes_hard_at"
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
    t.boolean  "target_by_location",         :default => false
    t.boolean  "location_target_by_address", :default => true
    t.string   "city"
    t.string   "postal_code"
    t.string   "region"
    t.string   "country"
    t.float    "radius"
    t.float    "lat"
    t.float    "lng"
    t.string   "approximate_address"
    t.boolean  "target_by_age_group",        :default => false
    t.boolean  "target_by_gender",           :default => false
    t.boolean  "target_by_occupation",       :default => false
    t.boolean  "target_by_education",        :default => false
    t.boolean  "target_by_ethnicity",        :default => false
    t.boolean  "target_by_race",             :default => false
    t.boolean  "target_by_survey",           :default => false
    t.integer  "targetable_id"
    t.string   "targetable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
