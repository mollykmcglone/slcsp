require 'spec_helper'

describe Importer do
  context 'initialize' do
    it 'sets a type attribute that represents the class of items to import' do
      class_name = "CountyRecord"
      importer = Importer.new(class_name)
      expect(importer.type).to eq(CountyRecord)
    end
  end

  context 'import' do
    let(:importer) { Importer.new("Plan") }
    let(:file_path) { "./csv_files/plans.csv" }

    it 'locates the file to import based on the file_name parameter' do
      expect { importer.import(file_path) }.to_not raise_error
    end

    it 'generates a new object for each row in the csv file, excluding the header row' do
      row_count = CSV.read(file_path, headers: true).count
      results = importer.import(file_path)
      expect(results.length).to eq(row_count)
    end

    it 'objects generated are of the expected type' do
      results = importer.import(file_path)
      expect(results[0]).to be_instance_of(Plan)
    end
  end
end
