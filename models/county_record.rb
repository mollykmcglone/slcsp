class CountyRecord
  FIELDS = [:zipcode, :state, :county_code, :county_name, :rate_area]
  attr_accessor *FIELDS

  def initialize(csv_row)
    self.zipcode = csv_row['zipcode']
    self.state = csv_row['state']
    self.county_code = csv_row['county_code']
    self.county_name = csv_row['name']
    self.rate_area = [csv_row['state'], csv_row['rate_area']]
  end
end
