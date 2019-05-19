require 'spec_helper'

describe Processor do
  let!(:processor) { Processor.new }

  context 'start' do
    before :each do
      allow_any_instance_of(Importer).to receive(:import)
      allow_any_instance_of(Zipcode).to receive(:determine_second_lowest_cost_silver_plan)
      allow_any_instance_of(Processor).to receive(:initialize_data)
      allow_any_instance_of(Processor).to receive(:process_plans)
      allow_any_instance_of(Processor).to receive(:output_results)
    end

    it 'imports data, processes plan information, and outputs the result' do
      expect_any_instance_of(Processor).to receive(:initialize_data)
      expect_any_instance_of(Processor).to receive(:process_plans)
      expect_any_instance_of(Processor).to receive(:output_results)
      processor.start
    end

    it 'handles an error importing data and displays a message to the user' do
      allow_any_instance_of(Processor).to receive(:initialize_data) { ArgumentError.new }
      expect { processor.start }.to_not raise_error
    end

    it 'handles other errors and displays a message to the user' do
      allow_any_instance_of(Processor).to receive(:process_plans) { StandardError.new }
      expect { processor.start }.to_not raise_error
    end
  end

  context 'initialize_data' do
    it 'imports plan, zipcode, and county_record data' do
      expect_any_instance_of(Processor).to receive(:import_data).exactly(3).times
      processor.send(:initialize_data)
    end
  end

  context 'import_data' do
    let!(:class_name) { "Plan" }

    it 'locates the file to import when passed a valid file_name parameter' do
      valid_file_name = "plans"
      expect { processor.send(:import_data, valid_file_name, class_name) }.to_not raise_error
    end

    it 'raises an error if the file to import cannot be located' do
      missing_file_name = "dreams"
      expect {
        processor.send(:import_data, missing_file_name, class_name)
      }.to raise_error(ArgumentError, "The expected file #{missing_file_name} cannot be located")
    end
  end

  context 'process_plans' do
    let!(:zipcodes) { Importer.new("Zipcode").import("spec/fixtures/test_slcsp.csv") }
    let!(:county_records) { Importer.new("CountyRecord").import("spec/fixtures/test_zips.csv") }
    let!(:plans) { Importer.new("Plan").import("spec/fixtures/test_plans.csv") }

    it 'determines the second lowest cost silver plan for each zipcode' do
      data = { zipcodes: zipcodes, county_records: county_records, plans: plans }
      zipcode = data[:zipcodes][0]
      expect(zipcode).to receive(:determine_second_lowest_cost_silver_plan).exactly(1).times
      processor.send(:process_plans, data)
    end
  end

  context 'output_results' do
    let!(:zipcodes) { Importer.new("Zipcode").import("spec/fixtures/test_slcsp.csv") }
    let!(:county_records) { Importer.new("CountyRecord").import("spec/fixtures/test_zips.csv") }
    let!(:plans) { Importer.new("Plan").import("spec/fixtures/test_plans.csv") }

    it 'generates a CSV file with a line for each zipcode' do
      results = zipcodes
      destination_file_path = 'spec/fixtures/test_slcsp_result.csv'
      output = processor.send(:output_results, results, destination_file_path)
      expect(output.length).to eq(3)
    end
  end
end
