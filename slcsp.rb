#!/usr/bin/env ruby
require 'csv'
require './models/processor.rb'
require './models/importer.rb'
require './models/county_record.rb'
require './models/zipcode.rb'
require './models/plan.rb'

processor = Processor.new
processor.start

# TODO: write processor specs
# TODO: figure out and implement "emit the CSV file via stdout"
# TODO: manual test to verify result for at least one zipcode
# TODO: write up instructions in a "Comments" file
# TODO: push to github
# TODO: test instructions on different machines (my work laptop and erik's dell)
