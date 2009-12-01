require 'rubygems'
require 'pathname'
require 'benchmark'
require 'dm-core'
require 'dm-aggregates'
require 'dm-serializer'
require 'dm-sweatshop'
require 'dm-validations'

modeldir = Pathname(__FILE__).dirname.expand_path / 'models'
tpccdir = Pathname(__FILE__).dirname.expand_path / 'tpcc'
$datadir = Pathname(__FILE__).dirname.expand_path / '..' / 'data'

require modeldir / 'customer'
require modeldir / 'district'
require modeldir / 'history'
require modeldir / 'item'
require modeldir / 'new_order'
require modeldir / 'order'
require modeldir / 'order_line'
require modeldir / 'stock'
require modeldir / 'warehouse'

require tpccdir / 'setup'
require tpccdir / 'load'
require tpccdir / 'benchmark'