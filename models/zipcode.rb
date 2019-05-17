require 'securerandom'

class Zipcode
  FIELDS = [:zipcode, :rate_areas, :plans, :slcsp]
  attr_accessor *FIELDS

  def initialize(csv_row)
    self.zipcode = csv_row['zipcode']
  end

  def calculate_slcsp(zip_records, plans)
    find_associated_rate_areas(zip_records)
    find_associated_plans(plans)
    find_second_lowest_cost_silver_plan
  end

  def find_associated_rate_areas(all_zip_records)
    zip_records_for_zipcode = all_zip_records.select { |zip_record| zip_record.zipcode == self.zipcode }

    rate_areas = []
    zip_records_for_zipcode.each do |zip_record|
      rate_area = [zip_record.state, zip_record.rate_area]
      rate_areas << rate_area
    end
    self.rate_areas = rate_areas.uniq
  end

  def find_associated_plans(all_plans)
    self.plans = all_plans.select { |plan| self.rate_areas.include?(plan.rate_area) }
  end

  def find_second_lowest_cost_silver_plan
    all_silver_plans = plans.select { |plan| plan.metal_level == 'Silver' }
    if all_silver_plans.length > 1
      sorted_plans = all_silver_plans.sort_by { |plan| plan.rate }
      second_lowest_cost_silver_plan = sorted_plans[1].rate
    end
    self.slcsp = second_lowest_cost_silver_plan ? second_lowest_cost_silver_plan : nil
  end
end
