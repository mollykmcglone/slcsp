require 'spec_helper'

describe Plan do
  context 'initialize' do
    let(:row) { CSV.open("spec/fixtures/test_plans.csv", headers: true, converters: :numeric) { |csv| csv.first } }
    let(:plan) { Plan.new(row) }

    it 'returns an object with attributes matching csv_row data' do
      expect(plan.id).to eq("50660KV6559607")
      expect(plan.state).to eq("GA")
      expect(plan.metal_level).to eq("Catastrophic")
      expect(plan.rate).to eq(250.12)
    end

    it 'sets the rate_area attribute to a tuple of [state, rate_area]' do
      expect(plan.rate_area).to eq(["GA", 1])
    end
  end
end
