#!/usr/bin/env ruby
require 'csv'
require './models/processor.rb'
require './models/importer.rb'
require './models/county_record.rb'
require './models/zipcode.rb'
require './models/plan.rb'

processor = Processor.new
processor.start
