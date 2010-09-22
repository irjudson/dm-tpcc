require 'benchmark'
require 'pathname'

modeldir = File.expand_path('models', File.dirname(__FILE__))
tpccdir  = File.expand_path('tpcc', File.dirname(__FILE__))

require modeldir / 'customer'
require modeldir / 'district'
require modeldir / 'history'
require modeldir / 'item'
require modeldir / 'new_order'
require modeldir / 'order'
require modeldir / 'order_line'
require modeldir / 'stock'
require modeldir / 'warehouse'

require tpccdir / 'version'
require tpccdir / 'setup'
require tpccdir / 'load'
require tpccdir / 'benchmark'
