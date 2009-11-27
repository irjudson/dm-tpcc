class Warehouse
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 10
  property :street1, String, :length => 20
  property :street2, String, :length => 20
  property :city, String, :length => 20
  property :state, String, :length => 2
  property :zip, String, :length => 9
  property :tax, Float
  property :ytd, Float
  
  has n, :districts
  has n, :stocks
end

Warehouse.fixture {{
  :name => /\w{10}/.gen,
  :street1 => /\w{20}/.gen,
  :street2 => /\w{20}/.gen,
  :city => /\w{20}/.gen,
  :state => /\w{2}/.gen,
  :zip => /\d{9}/.gen,
  :tax => /\d{4}\.\d{4}/.gen,
  :ytd => /\d{12}\.\d{2}/.gen,
  :stocks => 100000.of { Stock.make },
  :districts => 10.of { District.make }
}}
