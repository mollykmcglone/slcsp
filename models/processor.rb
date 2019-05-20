class Processor
  def start
    begin
      data = initialize_data
      results = process_plans(data)
      output_results(results)
    rescue ArgumentError => error
      puts "There was an error processing the input data: #{error.message}"
    rescue Exception => error
      puts "An error occurred: #{error.message}"
    end
  end

  private

  def initialize_data
    data = {}
    data[:county_records] = import_data("zips", "CountyRecord")
    data[:plans] = import_data("plans", "Plan")
    data[:zipcodes] = import_data("slcsp", "Zipcode")
    data
  end

  def import_data(file_name, class_name)
    file_path = "./csv_files/#{file_name}.csv"
    if File.exists?(file_path)
      importer = Importer.new(class_name)
      items = importer.import(file_path)
      items
    else
      raise ArgumentError.new("The expected file #{file_name} cannot be located")
    end
  end

  def process_plans(data)
    data[:zipcodes].each do |zipcode|
      zipcode.determine_second_lowest_cost_silver_plan(data[:county_records], data[:plans])
    end
    data[:zipcodes]
  end

  def output_results(results, filename = nil)
    headers = ["zipcode", "rate"]
    CSV() do |csv_out|
      puts "#{headers[0]}, #{headers[1]}"
      results.each do |zipcode|
        row = [zipcode.zipcode, zipcode.slcsp]
        csv_out << row
      end
    end
  end
end
