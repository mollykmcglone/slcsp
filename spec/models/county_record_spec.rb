require 'spec_helper'

describe CountyRecord do
  context 'initialize' do
    let(:row) { CSV.open("spec/fixtures/test_zips.csv", headers: true, converters: :numeric) { |csv| csv.first } }
    let(:county_record) { CountyRecord.new(row) }

    it 'returns an object with attributes matching csv_row data' do
      expect(county_record.zipcode).to eq(30728)
      expect(county_record.state).to eq("GA")
      expect(county_record.county_code).to eq(13295)
      expect(county_record.county_name).to eq("Walker")
    end

    it 'sets the rate_area attribute to a tuple of [state, rate_area]' do
      expect(county_record.rate_area).to eq(["GA", 7])
    end
  end
end
