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
  :image_id => /\d/.gen,
  :name => /\w+/.gen,
  :price => /\d{5}\.\d{2}/.gen,
  :data => /[:sentence:]/.gen[1..50],
  
  # 100000 for production
#  :stocks => 10.of { Stock.pick }
}}