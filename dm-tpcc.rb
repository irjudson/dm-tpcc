#!/usr/bin/env ruby
#
# This is a script to exercise your database with the TPC-C performance benchmark.
#
require 'lib/dm-tpcc'
require 'ruby-debug'

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
#DataMapper::TPCC::setup :default
DataMapper::TPCC::init

#
# This loads the initial test data into the database
#  Pass a scale factor which is a number of warehouses to create
#

#DataMapper::TPCC::generate 1
#DataMapper::TPCC::save
#DataMapper::TPCC::load

#
# This measures the performance of the database
#

bm = DataMapper::TPCC::Benchmark.new

puts "Doing a new order transaction"
bm.new_order

puts "Doing a payment transaction"
bm.payment

puts "Doing a order status transaction"
bm.order_status

puts "Doing a deliver transaction"
bm.delivery

puts "Doing a stock level transaction"
bm.stock_level