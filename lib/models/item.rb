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
  :image_id => DataMapper::TPCC::random(0,200000),
  :name => /\w{6,24}/.gen,
  :price => (/\d{1,3}\.\d{2}/.gen).to_f,
  :data => /[:sentence:]/.gen[1..50]
}}