class District
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
  property :next_order_number, Integer
#  property :warehouse_id, Integer, :key => true

  has n, :customers, :child_key => :district_id
  
  belongs_to :warehouse, :required => false
end

District.fixture {{
  :name => /\w{6,10}/.gen,
  :street1 => /\w{10,20}/.gen,
  :street2 => /\w{10,20}/.gen,
  :city => /\w{10,20}/.gen,
  :state => /\w{2}/.gen,
  :zip => /\d{4}11111/.gen,
  :tax => DataMapper::TPCC::random(0,2000)/10000.0,
  :ytd => 30000.00,
  :next_order_number => 30001
}}