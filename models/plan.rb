class Plan
  FIELDS = [:id, :state, :metal_level, :rate, :rate_area]
  attr_accessor *FIELDS

  def initialize(csv_row)
    self.id = csv_row['plan_id']
    self.state = csv_row['state']
    self.metal_level = csv_row['metal_level']
    self.rate = csv_row['rate']
    self.rate_area = [csv_row['state'], csv_row['rate_area']]
  end
end
