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
  
  belongs_to :warehouse
  belongs_to :item
end

Stock.fixture {{
  :quantity => /\d{4}/.gen,
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
  :ytd => /\d{8}/.gen,
  :order_count => /\d{4}/.gen,
  :remote_count => /\d{4}/.gen,
  :data => /[:sentence:]/.gen[1..50],
  :order_lines => 3.of { OrderLine.pick }
}}
