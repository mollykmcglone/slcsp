class Zipcode
  FIELDS = [:zipcode, :rate_areas, :plans, :slcsp]
  attr_accessor *FIELDS

  def initialize(csv_row)
    self.zipcode = csv_row['zipcode']
  end

  def determine_second_lowest_cost_silver_plan(county_records = nil, plans = nil)
    find_associated_rate_areas(county_records)
    find_associated_plans(plans)
    if can_determine_slcsp?
      self.slcsp = get_rate_of_second_lowest_cost_silver_plan
    else
      self.slcsp = nil
    end
  end

  private

  def find_associated_rate_areas(all_county_records = nil)
    county_records_for_zipcode = all_county_records.select { |record| record.zipcode == self.zipcode }
    rate_areas = []
    county_records_for_zipcode.each do |record|
      rate_areas << record.rate_area
    end
    self.rate_areas = rate_areas.uniq
  end

  def find_associated_plans(all_plans = nil)
    self.plans = all_plans.select { |plan| self.rate_areas.include?(plan.rate_area) }
  end

  def can_determine_slcsp?
    # can only determine slcsp if zipcode is present in exactly one rate area
    self.rate_areas.length == 1
  end

  def find_silver_plans
    plans.select { |plan| plan.metal_level == 'Silver' }
  end

  def get_rate_of_second_lowest_cost_silver_plan
    silver_plans = find_silver_plans
    rate = nil
    # cannot set slcsp if there are no silver plans or only one silver plan
    if silver_plans && silver_plans.length > 1
      sorted_plans = silver_plans.sort_by { |plan| plan.rate }
      rate = sorted_plans[1].rate
    end
    rate
  end
end
