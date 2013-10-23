class RemotePerson < ActiveRecord::Base
  self.establish_connection :remote
  
  def self.columns() @columns ||= []; end
  
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  column :case_id, :string
  column :case_type, :string
  column :name, :string
  column :external_id, :string
	column :owner_id, :string
	column :date_modified, :date
	column :given_name, :string
	column :middle_name, :string
	column :family_name_prefix, :string
	column :family_name, :string
	column :family_name2, :string
	column :gender, :string
	column :birthdate, :date
	column :birthdate_estimated, :integer
	column :dead, :integer
	column :death_date, :date
	column :cause_of_death, :string
	column :national_id, :string
	column :address1, :string
	column :address2, :string
	column :city_village, :string
	column :state_province, :string
	column :postal_code, :string
	column :country, :string
	column :county_district, :string
	column :neighborhood_cell, :string
	column :region, :string
	column :subregion, :string
	column :township_division, :string
  
end
