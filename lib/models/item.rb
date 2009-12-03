class Item
  include DataMapper::Resource

  property :id, Serial
  property :image_id, Integer
  property :name, String, :length => 24
  property :price, Float
  property :data, String, :length => 50
  
  has n, :stocks
end

Item.fixture {{
  :image_id => DataMapper::TPCC::random(1,10000),
  :name => /\w{14,24}/.gen,
  :price => DataMapper::TPCC::random(1.0,100.0),
  :data => DataMapper::TPCC::random_string(26, 50, encode="ORIGINAL", percent=10)
}}