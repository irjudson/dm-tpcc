#!/usr/bin/env ruby

require 'lib/dm-tpcc'
require 'benchmark'

iter = 1000
size = 500

Benchmark.bm do |x|
  x.report("DM::TPCC: "){ iter.times do ; DataMapper::TPCC::random_string(500,500) ; end }
  x.report("Randgen: "){ iter.times do ; /[:paragraph:]{10}/.gen[0,500]  ; end }    
  x.report("Char Cat: "){ iter.times do ; str = ""; size.of { str << Randgen.char }; str; end }    
  x.report("Char Join: "){ iter.times do ; size.of { Randgen.char }.join("") ; end }    
end