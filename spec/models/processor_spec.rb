require 'spec_helper'

describe Processor do
  let!(:processor) { Processor.new }
  let!(:results) { processor.start }

  # context 'start' do
  #   it 'imports data from csv files and creates zipcode, plan, and county_record objects' do
  #     processor.start
  #     expect()
  #
  #   end
  # end

  context 'import_data' do
    it 'raises an error if the file to import cannot be located' do
      missing_file_name = "dreams"
      expect { processor.send(:import_data, missing_file_name, "Plan") }.to raise_error(ArgumentError, "The file #{missing_file_name} does not exist")
    end
  end
end
