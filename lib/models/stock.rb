class Stock
  include DataMapper::Resource

  property :id, Serial
  property :quantity, Integer
  property :district_01, String, :length => 24
  property :district_02, String, :length => 24
  property :district_03, String, :length => 24
  property :district_04, String, :length => 24
  property :district_05, String, :length => 24
  property :district_06, String, :length => 24
  property :district_07, String, :length => 24
  property :district_08, String, :length => 24
  property :district_09, String, :length => 24
  property :district_10, String, :length => 24
  property :ytd, Integer
  property :order_count, Integer
  property :remote_count, Integer
  property :data, String, :length => 50
  
  has n, :order_lines
  
  belongs_to :warehouse, :required => false
  belongs_to :item, :required => false
end

Stock.fixture {{
  :quantity => DataMapper::TPCC::random(10,100),
  :district_01 => /\w{24}/.gen,
  :district_02 => /\w{24}/.gen,
  :district_03 => /\w{24}/.gen,
  :district_04 => /\w{24}/.gen,
  :district_05 => /\w{24}/.gen,
  :district_06 => /\w{24}/.gen,
  :district_07 => /\w{24}/.gen,
  :district_08 => /\w{24}/.gen,
  :district_09 => /\w{24}/.gen,
  :district_10 => /\w{24}/.gen,
  :ytd => 0, 
  :order_count => 0,
  :remote_count => 0,
  :data => /[:paragraph:]/.gen.slice(0, DataMapper::TPCC::random(26,50))
}}
