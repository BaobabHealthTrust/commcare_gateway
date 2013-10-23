class SyncController < ApplicationController

  def cchqrequest(url, file = nil)
    result = ""
    
    settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env] rescue {}
    
    user = settings["cchq_user"]
    pass = settings["cchq_pass"]
    
    if !file.nil?
    
      result = `curl -F "xml_submission_file=@#{file}" "#{url}"`
    
      p result
    
      File.delete "#{file}" if File.exists?("#{file}")
    
    else 
    
      p "curl --digest -u #{user}:#{pass} \"#{url}\""
    
      result = `curl --digest -u #{user}:#{pass} "#{url}"`
    
      p result
    
    end
    
    result
  end

  def load_patients
  
    settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env] rescue {}
    
    village_id = settings["cchq_village_id"]
  
    records = RemotePerson.find_by_sql("SELECT DISTINCT MD5((SELECT identifier FROM patient_identifier WHERE patient_id = person.person_id AND identifier_type = 3 AND voided = 0 LIMIT 1)) case_id, given_name, middle_name, family_name_prefix, family_name, family_name2, gender, birthdate, birthdate_estimated, dead, death_date, CASE COALESCE(cause_of_death,0) WHEN 0 THEN NULL ELSE (SELECT name FROM concept_name WHERE concept_id = cause_of_death LIMIT 1) END cause_of_death, (SELECT identifier FROM patient_identifier WHERE patient_id = person.person_id AND identifier_type = 3 AND voided = 0 LIMIT 1) national_id, address1, address2, city_village, state_province, postal_code, country, county_district FROM person_name LEFT OUTER JOIN person ON person.person_id = person_name.person_id LEFT OUTER JOIN person_address ON person.person_id = person_address.person_id WHERE COALESCE((SELECT identifier FROM patient_identifier WHERE patient_id = person.person_id AND identifier_type = 3 AND voided = 0 LIMIT 1),'') != '' AND COALESCE(person.voided, 0) = 0")
    
    output = ""
    
    records.each do |record|
        person = Person.find_or_create_by_case_id(
         
          :case_id => record["case_id"]      
            
        )
    
        dirty = false
        
        if person[:case_type] != "person"
          dirty = true
          
          output = "case_type failed<br />" + output
          
        elsif person[:external_id] != record["national_id"]
	        dirty = true
          
          output = "external_id failed<br />" + output
          
        elsif person[:owner_id] != village_id
	        dirty = true
          
          output = "owner_id failed<br />" + output
          
        elsif person[:given_name] != record["given_name"]
	        dirty = true
          
          output = "given_name failed<br />" + output
          
        elsif person[:middle_name] != record["middle_name"]
	        dirty = true
          
          output = "middle_name failed<br />" + output
          
        elsif person[:family_name_prefix] != record["family_name_prefix"]
	        dirty = true
          
          output = "family_name_prefix failed<br />" + output
          
        elsif person[:family_name] != record["family_name"]
	        dirty = true
          
          output = "family_name failed<br />" + output
          
        elsif person[:family_name2] != record["family_name2"]
	        dirty = true
          
          output = "family_name2 failed<br />" + output
          
        elsif person[:gender] != record["gender"]
	        dirty = true
          
          output = "gender failed<br />" + output
          
        elsif person[:birthdate] != record["birthdate"]
	        dirty = true
          
          output = "birthdate failed<br />" + output
          
        elsif person[:birthdate_estimated] != record["birthdate_estimated"]
	        dirty = true
          
          output = "birthdate_estimated failed<br />" + output
          
        elsif person[:dead] != record["dead"]
	        dirty = true
          
          output = "dead failed<br />" + output
          
        elsif person[:death_date] != record["death_date"]
	        dirty = true
          
          output = "death_date failed<br />" + output
          
        elsif person[:cause_of_death] != record["cause_of_death"]
	        dirty = true
          
          output = "cause_of_death failed<br />" + output
          
        elsif person[:national_id] != record["national_id"]
	        dirty = true
          
          output = "national_id failed<br />" + output
          
        elsif person[:address1] != record["address1"]
	        dirty = true
          
          output = "address1 failed<br />" + output
          
        elsif person[:address2] != record["address2"]
	        dirty = true
          
          output = "address2 failed<br />" + output
          
        elsif person[:city_village] != record["city_village"]
	        dirty = true
          
          output = "city_village failed<br />" + output
          
        elsif person[:state_province] != record["state_province"]
	        dirty = true
          
          output = "state_province failed<br />" + output
          
        elsif person[:postal_code] != record["postal_code"]
	        dirty = true
          
          output = "postal_code failed<br />" + output
          
        elsif person[:country] != record["country"]
	        dirty = true
          
          output = "country failed<br />" + output
          
        elsif person[:county_district] != record["county_district"]
	        dirty = true
          
          output = "county_district failed<br />" + output
          
        end
    
        if dirty
          person.update_attributes(
            {
            :case_type => "person",
            :name => "#{record["given_name"]} #{record["family_name"]}",
            :external_id => record["national_id"],
            :owner_id => village_id,
            :date_modified => Date.today.strftime("%Y-%m-%d"),
            :given_name => record["given_name"],
            :middle_name => record["middle_name"],
            :family_name_prefix => record["family_name_prefix"],
            :family_name => record["family_name"],
            :family_name2 => record["family_name2"],
            :gender => record["gender"],
            :birthdate => record["birthdate"],
            :birthdate_estimated => record["birthdate_estimated"],
            :dead => record["dead"],
            :death_date => record["death_date"],
            :cause_of_death => record["cause_of_death"],
            :national_id => record["national_id"],
            :address1 => record["address1"],
            :address2 => record["address2"],
            :city_village => record["city_village"],
            :state_province => record["state_province"],
            :postal_code => record["postal_code"],
            :country => record["country"],
            :county_district => record["county_district"],
            :sync_with_cchq => 1
          }) 
        end
    
    end
    
    render :text => "OK" # + "<br />" + output
    
  end

  def push_create_patients
  
    settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env] rescue {}
    
    village_id = settings["cchq_village_id"]
  
    user_id = settings["cchq_user_id"]
  
    xml = "<?xml version='1.0' ?><data uiVersion='1' version='1' name='Cases Modification' " + 
          "xmlns:jrm='http://dev.commcarehq.org/jr/xforms' " + 
          "xmlns='http://openrosa.org/formdesigner/08E9CB53-029A-43A7-BE6B-90604F72A3AA'>"
          
    i = 0
       
    fields = ["external_id", "given_name", "middle_name", "family_name_prefix", "family_name", "family_name2", "gender", "birthdate", "birthdate_estimated", "dead", "death_date", "cause_of_death", "national_id", "address1", "address2", "city_village", "state_province", "postal_code", "country", "county_district", "neighborhood_cell", "region", "subregion", "township_division"]
          
    Person.find(:all, :limit => 50, :conditions => ["COALESCE(mapped_to_cchq, 0) = 0 " + 
        "AND COALESCE(cchq_closed, 0) = 0"]).each do |patient|
        
        xml += "<n#{i}:case case_id='#{patient["case_id"]}' date_modified='#{patient["date_modified"]}#{Time.now.strftime("T%H:%M:%S%z")}' user_id='#{user_id}' xmlns:n#{i}='http://commcarehq.org/case/transaction/v2'>"
        
        xml += "<n#{i}:create>"
        
        xml += "<n#{i}:case_name>#{patient["name"]}</n#{i}:case_name>"
        
        xml += "<n#{i}:owner_id>#{village_id}</n#{i}:owner_id>"
        
        xml += "<n#{i}:case_type>#{patient["case_type"]}</n#{i}:case_type>"
        
        xml += "</n#{i}:create>"
        
        xml += "<n#{i}:update>"
        
        fields.each{|field|
          
          xml += "<n#{i}:#{field}>#{patient[field]}</n#{i}:#{field}>"
          
        }
        
        xml += "</n#{i}:update>"
        
        xml += "</n#{i}:case>"
        
        patient.update_attributes({:sync_with_cchq => 0, :mapped_to_cchq => 1})
        
        i += 1
        
    end
          
    xml += "<n#{i}:meta xmlns:n#{i}='http://openrosa.org/jr/xforms'><n#{i}:username>sync</n#{i}:username>" +
        "<n#{i}:userID>#{user_id}</n#{i}:userID><n#{i}:timeStart>#{Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")}</n#{i}:timeStart>" +
        "<n#{i}:timeEnd>#{Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")}</n#{i}:timeEnd></n#{i}:meta></data>"
  
    Dir.mkdir("#{Rails.root}/tmp") if !File.exists?("#{Rails.root}/tmp")
  
    filename = "#{Rails.root}/tmp/create_patients_#{Time.now.to_i}.xml"
    
    file = File.open("#{filename}", "w+")
    
    file.write(xml)
    
    file.close
    
    project = settings["cchq_project"]
    
    url = "https://www.commcarehq.org/a/#{project}/receiver/"
    
    cchqrequest(url, filename)
  
    render :xml => xml
  
  end

  def push_update_patients
  
    settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env] rescue {}
    
    village_id = settings["cchq_village_id"]
  
    user_id = settings["cchq_user_id"]
  
    xml = "<?xml version='1.0' ?><data uiVersion='1' version='1' name='Cases Modification' " + 
          "xmlns:jrm='http://dev.commcarehq.org/jr/xforms' " + 
          "xmlns='http://openrosa.org/formdesigner/08E9CB53-029A-43A7-BE6B-90604F72A3AA'>"
          
    i = 0
       
    fields = ["name", "external_id", "given_name", "middle_name", "family_name_prefix", "family_name", "family_name2", "gender", "birthdate", "birthdate_estimated", "dead", "death_date", "cause_of_death", "national_id", "address1", "address2", "city_village", "state_province", "postal_code", "country", "county_district", "neighborhood_cell", "region", "subregion", "township_division"]
          
    Person.find(:all, :limit => 20, :conditions => ["COALESCE(sync_with_cchq, 0) = 1 AND COALESCE(mapped_to_cchq, 0) = 1 " + 
        "AND COALESCE(cchq_closed, 0) = 0"]).each do |patient|
        
        xml += "<n#{i}:case case_id='#{patient["case_id"]}' date_modified='#{patient["date_modified"]}#{Time.now.strftime("T%H:%M:%S%z")}' user_id='#{user_id}' xmlns:n#{i}='http://commcarehq.org/case/transaction/v2'>"
        
        xml += "<n#{i}:update>"
        
        fields.each{|field|
          
          xml += "<n#{i}:#{field}>#{patient[field]}</n#{i}:#{field}>"
          
        }
        
        xml += "</n#{i}:update>"
        
        xml += "</n#{i}:case>"
        
        patient.update_attributes({:sync_with_cchq => 0})
        
        i += 1
        
    end
          
    xml += "<n#{i}:meta xmlns:n#{i}='http://openrosa.org/jr/xforms'><n#{i}:username>sync</n#{i}:username>" +
        "<n#{i}:userID>#{user_id}</n#{i}:userID><n#{i}:timeStart>#{Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")}</n#{i}:timeStart>" +
        "<n#{i}:timeEnd>#{Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")}</n#{i}:timeEnd></n#{i}:meta></data>"
  
    Dir.mkdir("#{Rails.root}/tmp") if !File.exists?("#{Rails.root}/tmp")
  
    filename = "#{Rails.root}/tmp/update_patients_#{Time.now.to_i}.xml"
    
    file = File.open("#{filename}", "w+")
    
    file.write(xml)
    
    file.close
    
    project = settings["cchq_project"]
    
    url = "https://www.commcarehq.org/a/#{project}/receiver/"
    
    cchqrequest(url, filename)
  
    render :xml => xml
  
  end

  def pull_patients
  
    settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env] rescue {}
    
    project = settings["cchq_project"]
    
    version = settings["cchq_version"]
    
    url = "https://www.commcarehq.org/a/#{project}/api/v#{version}/case/?format=json&type=person"
    
    result = cchqrequest(url)
        
    result = JSON.parse(result)
        
    render :json => result
  
  end

end
