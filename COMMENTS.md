# How to use this project

## Setup

You will need to have ruby installed on your local system (if you are on Linux/Mac you probably already do).  To verify it's installed, `ruby -v` from the command line. If you need to install Ruby, instructions are here: https://www.ruby-lang.org/en/documentation/installation/

To run the tests for the project you will need to install the test runner gem, rspec. This will require you to have bundler installed and working on your system. Information on installing bundler is is here:

Once bundler is installed, run `bundle install` from the project's root directory to install the rspec gem.

## Run the code

This code determines the second lowest cost silver plan (SLCSP) for each zipcode in the zips.csv file located at `csv_files/zips.csv`.  

To run the code:

* From the project's root directory, run `generate_slcsp.rb`
* You should see the generated SLCSP for each zipcode emitted on stdout

## Run the tests

There is a small test suite verifying that this code is behaving as expected.  To run the test suite:

*  From the project's root directory, run `bundle exec rspec`
