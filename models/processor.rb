class Processor
  def start
    data = initialize_data
    results = process_plans(data)
    output(results)
  end

  private

  def initialize_data
    data["county_records"] = import_data("zips", "CountyRecord")
    data["plans"] = import_data("plans", "Plan")
    data["zipcodes"] = import_data("slcsp", "Zipcode")
  end

  def import_data(file_name, class_name)
    file_path = "./csv_files/#{file_name}.csv"
    if File.exists?(file_path)
      importer = Importer.new(class_name)
      items = Importer.import(file_path)
      puts "Created #{items.length} #{class_name}'s!"
      items
    else
      raise ArgumentError.new("The file #{file_name} does not exist")
    end
  end

  def process_plans(data)
    data["zipcodes"].each do |zipcode|
      zipcode.determine_second_lowest_cost_silver_plan(data["county_records"], data["plans"])
      puts "SLCSP for zipcode: #{zipcode.zipcode} is #{zipcode.slcsp}"
    end
    data
  end

  def output(results)
    puts "Result!"
    headers = ["zipcode", "rate"]
    CSV.open('./csv_files/slcsp_result.csv','w', :write_headers=> true, :headers => headers) do |file|
      results["zipcodes"].each do |zipcode|
        row = [zipcode.zipcode, zipcode.slcsp]
        file << row
      end
    end
  end
end
