#!/usr/bin/env ruby
require './models/processor.rb'
require './models/importer.rb'
require './models/zip_record.rb'
require './models/zipcode.rb'
require './models/plan.rb'

Processor.start

# import_plans(plans.csv)
# - read through the csv file and...
# - create Plan objects
# - create RateArea objects
# - tests:
#   - number of lines on file corresponds to number of objects created
#   - object has expected attributes
#   - object has expected relationships
#
# import_zips(zips.csv)
# - read through the csv file and
# - create Zipcode objects
# - create (more) RateArea objects
# - tests:
#   - number of lines on file corresponds to number of objects created
#   - object has expected attributes
#   - object has expected relationships
#
# calculate_slcsp_for_zip_codes()
# - for each Zipcode,
# - figure out the slcsp (likely to be multiple sub-methods, scopes, etc. involved)
# - and store it as an attribute on the zip_code
# - tests:
#   - given an input, output is expected (for method/submethods)
#   - maybe using data in csv files, or maybe using a subset of the data for testing
#
# generate_output()
# - populate the slcsp.csv with the calculated slcsps
# - emit the updated file "as a CSV on stdout"
# - tests:
#   - data in file is in correct order
#   - data in file is correct (value for zip corresponds to attribute on object)
#   - empty spaces are present as expected when data is not available
