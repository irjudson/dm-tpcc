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
#
DataMapper::TPCC.setup # :default is default

#
# This loads the initial test data into the database
#
DataMapper::TPCC::load 1 # Scale factor, number of warehouses

#
# This measures the performance of the database
#
#DataMapper::TPCC::benchmark