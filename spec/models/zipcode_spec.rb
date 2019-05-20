require 'spec_helper'

describe Zipcode do
  let!(:row) { CSV.open("spec/fixtures/test_slcsp.csv", headers: true, converters: :numeric) { |csv| csv.first } }
  let!(:zipcode) { Zipcode.new(row) }

  context 'initialize' do
    it 'returns an object with zipcode attribute matchig csv_row data' do
      expect(zipcode.zipcode).to eq(30728)
    end
  end

  context 'find_associated_rate_areas' do
    let(:importer) { Importer.new("CountyRecord") }
    let(:all_county_records) { importer.import("spec/fixtures/test_zips.csv") }

    it 'returns an array of rate_areas when the zipcode is present in multiple rate areas' do
      rate_areas = zipcode.send(:find_associated_rate_areas, all_county_records)
      expect(rate_areas.length).to eq(2)
      expect(rate_areas).to eq([all_county_records[0].rate_area, all_county_records[3].rate_area])
    end

    it 'returns an array containing one rate_area when the zipcode is present in one rate area' do
      all_county_records.delete_at(3)
      rate_areas = zipcode.send(:find_associated_rate_areas, all_county_records)
      expect(rate_areas.length).to eq(1)
      expect(rate_areas).to eq([all_county_records[0].rate_area])
    end

    it 'returns an empty array when the zipcode is not present in any rate areas' do
      all_county_records.delete_at(3)
      all_county_records.delete_at(0)
      rate_areas = zipcode.send(:find_associated_rate_areas, all_county_records)
      expect(rate_areas).to eq([])
    end
  end

  context 'find_associated_plans' do
    let!(:importer) { Importer.new("Plan")}
    let!(:all_plans) { importer.import("spec/fixtures/test_plans.csv") }

    it 'returns an array of plans when the zipcode has multiple associated plans' do
      zipcode.rate_areas = [["GA", 7]]
      plans = zipcode.send(:find_associated_plans, all_plans)
      expect(plans).to eq([all_plans[1], all_plans[2]])
    end

    it 'returns an array with one plan when the zipcode has one associated plan' do
      zipcode.rate_areas = [["GA", 7]]
      all_plans.delete_at(2)
      plans = zipcode.send(:find_associated_plans, all_plans)
      expect(plans).to eq([all_plans[1]])
    end

    it 'returns an emmpty array when the zipcode has no associated plans' do
      zipcode.rate_areas = [["GA", 7]]
      all_plans.delete_at(2)
      all_plans.delete_at(1)
      plans = zipcode.send(:find_associated_plans, all_plans)
      expect(plans).to eq([])
    end
  end

  context 'determine_second_lowest_cost_silver_plan' do
    before :each do
      allow_any_instance_of(Zipcode).to receive(:find_associated_rate_areas)
      allow_any_instance_of(Zipcode).to receive(:find_associated_plans)
    end

    context 'slcsp cannot be determined' do
      let!(:importer) { Importer.new("Plan")}
      let!(:all_plans) { importer.import("spec/fixtures/test_plans.csv") }
      let!(:plan) { all_plans[1] }

      it 'when zipcode is present in multiple rate_areas' do
        zipcode.rate_areas = [["GA", 7], ["GA", 6], ["GA", 5]]
        zipcode.determine_second_lowest_cost_silver_plan
        expect(zipcode.slcsp).to eq(nil)
      end

      it 'when zipcode is not present in any rate_areas' do
        zipcode.rate_areas = []
        zipcode.determine_second_lowest_cost_silver_plan
        expect(zipcode.slcsp).to eq(nil)
      end

      it 'when zipcode only has one silver plan' do
        zipcode.rate_areas = [["GA", 7]]
        zipcode.plans = [plan]
        zipcode.determine_second_lowest_cost_silver_plan
        expect(zipcode.slcsp).to eq(nil)
      end

      it 'when zipcode does not have any silver plans' do
        plan.metal_level = "Gold"
        zipcode.plans = [plan]
        zipcode.rate_areas = [["GA", 7]]

        zipcode.determine_second_lowest_cost_silver_plan
        expect(zipcode.slcsp).to eq(nil)
      end
    end

    context 'slcsp can be determined' do
      let!(:importer) { Importer.new("Plan")}
      let!(:all_plans) { importer.import("spec/fixtures/test_plans.csv") }
      let!(:plan1) { all_plans[1] }
      let!(:plan2) { all_plans[2] }

      it 'when zipcode is present in one rate area and has multiple silver plans' do
        zipcode.rate_areas = [["GA", 7]]
        zipcode.plans = [plan1, plan2]
        zipcode.determine_second_lowest_cost_silver_plan
        expect(zipcode.slcsp).to eq(plan1.rate)
      end
    end
  end
end
