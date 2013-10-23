class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :case_id
      t.string :case_type
      t.string :name
      t.string :external_id
      t.string :owner_id
      t.date :date_modified
      t.string :given_name
      t.string :middle_name
      t.string :family_name_prefix
      t.string :family_name
      t.string :family_name2
      t.string :gender
      t.date :birthdate
      t.integer :birthdate_estimated
      t.integer :dead
      t.date :death_date
      t.string :cause_of_death
      t.string :national_id
      t.string :address1
      t.string :address2
      t.string :city_village
      t.string :state_province
      t.string :postal_code
      t.string :country
      t.double :latitude
      t.double :longitude
      t.string :county_district
      t.string :neighborhood_cell
      t.string :region
      t.string :subregion
      t.string :township_division
      t.integer :sync_with_cchq
      t.integer :mapped_to_cchq
      t.integer :cchq_closed

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
