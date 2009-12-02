#!/usr/bin/env ruby
#
# This is a script to exercise your database with the TPC-C performance benchmark.
#
require 'lib/dm-tpcc'

# Find an elegant way to have logging optional
#DataMapper::TPCC::logger = DataMapper::Logger.new(STDOUT, 0)

# Find an elegant way to turn debugging verbosity on.

#
# Connect to a database to test
#
#DataMapper.setup(:default, :adapter => :in_memory)
#DataMapper.setup(:default, "sqlite3::memory:")
DataMapper.setup(:default, "mysql://localhost/tpcc")

#
# This sets up the database/repository connections and creates the database structure
#  Pass the repository to use to setup
#
DataMapper::TPCC::setup :default
DataMapper::TPCC::init

#
# This loads the initial test data into the database
#  Pass a scale factor which is a number of warehouses to create
#

DataMapper::TPCC::generate 1
DataMapper::TPCC::save
DataMapper::TPCC::load

#
# This measures the performance of the database
#
DataMapper::TPCC::benchmark