#!/usr/bin/env ruby
#
# This is a script to exercise your database with the TPC-C performance benchmark.
#
require 'lib/dm-tpcc'

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
DataMapper::TPCC.setup :default

#
# This loads the initial test data into the database
#  Pass a scale factor which is a number of warehouses to create
#
DataMapper::TPCC::load 1

#
# This measures the performance of the database
#
DataMapper::TPCC::benchmark