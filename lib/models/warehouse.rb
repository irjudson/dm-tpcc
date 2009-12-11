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
  has n, :new_orders
  has n, :customers
  has n, :histories
  has n, :orders
  has n, :order_lines
  
end

Warehouse.fixture {{
  :name => /\w{6,10}/.gen,
  :street1 => /\w{10,20}/.gen,
  :street2 => /\w{10,20}/.gen,
  :city => /\w{10,20}/.gen,
  :state => /\w{2}/.gen,
  :zip => /\d{4}11111/.gen,
  :tax => DataMapper::TPCC::random(0,2000)/10000.0,
  :ytd => 300000.00
}}
