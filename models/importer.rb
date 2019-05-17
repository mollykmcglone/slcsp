require 'csv'

class Importer
  def self.import_zip_records
    file = "./csv_files/zips.csv"
    zip_records = []
    CSV.foreach(file, headers: true) do |row|
      new_record = ZipRecord.new(row)
      zip_records << new_record
    end
    zip_records
  end

  def self.import_plans
    file = "./csv_files/plans.csv"
    plans = []
    CSV.foreach(file, headers: true) do |row|
      new_plan = Plan.new(row)
      plans << new_plan
    end
    plans
  end

  def self.import_zipcodes
    file = "./csv_files/slcsp.csv"
    zipcodes = []
    CSV.foreach(file, headers: true) do |row|
      new_zipcode = Zipcode.new(row)
      zipcodes << new_zipcode
    end
    zipcodes
  end
end
