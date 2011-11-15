class RemoveMemberDemos < ActiveRecord::Migration
  def up
    drop_table :ethnicities_members
    drop_table :members_races
    remove_column :members, :gender_id
    remove_column :members, :education_id
    remove_column :members, :birthmonth
    remove_column :members, :address_1
    remove_column :members, :address_2
    remove_column :members, :city
    remove_column :members, :state
    remove_column :members, :postal_code
    remove_column :members, :country
    remove_column :members, :lat
    remove_column :members, :lng
    remove_column :members, :first_name
    remove_column :members, :last_name
    remove_column :members, :privacy_dont_show_location    
    
    create_table "ethnicities_participants", :id => false, :force => true do |t|
      t.integer "participant_id"
      t.integer "ethnicity_id"
    end
    create_table "participants_races", :id => false, :force => true do |t|
      t.integer "participant_id"
      t.integer "race_id"
    end
    add_column :participants, :gender_id, :integer
    add_column :participants, :education_id, :integer
    add_column :participants, :birthmonth, :date
    add_column :participants, :city, :string
    add_column :participants, :state, :string
    add_column :participants, :postal_code, :string
    add_column :participants, :country, :string
    add_column :participants, :lat, :float
    add_column :participants, :lng, :float
    
    add_column :participant_surveys, :lat, :float
    add_column :participant_surveys, :lng, :float
    remove_column :participant_surveys, :destroy_participant_survey
    remove_column :participant_surveys, :old_city
    remove_column :participant_surveys, :old_state
    remove_column :participant_surveys, :old_postal_code
    remove_column :participant_surveys, :old_region_id
    remove_column :participant_surveys, :race_ids_cache
    remove_column :participant_surveys, :ethnicity_ids_cache
  end

  def down
    create_table "ethnicities_members", :id => false, :force => true do |t|
      t.integer "member_id"
      t.integer "ethnicity_id"
    end
    create_table "members_races", :id => false, :force => true do |t|
      t.integer "member_id"
      t.integer "race_id"
    end
    add_column :members, :gender_id, :integer
    add_column :members, :education_id, :integer
    add_column :members, :birthmonth, :date
    add_column :members, :address_1, :string
    add_column :members, :address_2, :string
    add_column :members, :city, :string
    add_column :members, :state, :string
    add_column :members, :postal_code, :string
    add_column :members, :country, :string
    add_column :members, :lat, :float
    add_column :members, :lng, :float
    add_column :members, :first_name, :string
    add_column :members, :last_name, :string  
    add_column :members, :privacy_dont_show_location , :boolean, :default => false
    
    drop_table :ethnicities_participants
    drop_table :participants_races
    remove_column :participants, :gender_id
    remove_column :participants, :education_id
    remove_column :participants, :birthmonth
    remove_column :participants, :city
    remove_column :participants, :state
    remove_column :participants, :postal_code
    remove_column :participants, :country
    remove_column :participants, :lat
    remove_column :participants, :lng
    
    remove_column :participant_surveys, :lat
    remove_column :participant_surveys, :lng
    add_column :participant_surveys, :destroy_participant_survey, :boolean, :default => false
    add_column :participant_surveys, :old_city, :string
    add_column :participant_surveys, :old_state, :string
    add_column :participant_surveys, :old_postal_code, :string
    add_column :participant_surveys, :old_region_id, :integer
    add_column :participant_surveys, :race_ids_cache, :string
    add_column :participant_surveys, :ethnicity_ids_cache, :string
  end
end
