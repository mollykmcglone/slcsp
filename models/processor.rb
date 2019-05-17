class Processor
  def self.start
    zip_records = Importer.import_zip_records
    puts "Created #{zip_records.length} zip_records!"

    plans = Importer.import_plans
    puts "Created #{plans.length} plans!"

    zipcodes = Importer.import_zipcodes
    puts "Created #{zipcodes.length} zipcodes!"

    zipcodes.each do |zipcode|
      zipcode.calculate_slcsp(zip_records, plans)
      puts "SLCSP for zipcode: #{zipcode.zipcode} is #{zipcode.slcsp}"
    end
  end
end
