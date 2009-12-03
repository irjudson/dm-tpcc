#!/usr/bin/env ruby
#
require 'lib/dm-tpcc'
DataMapper.setup(:default, "mysql://localhost/tpcc")
DataMapper::TPCC::init
bm = DataMapper::TPCC::Benchmark.new
bm.run("two_hour.csv", 7200)