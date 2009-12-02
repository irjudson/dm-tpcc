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
#  property :next_order_number, Integer
  property :warehouse_id, Integer, :key => true

  has n, :customers
  
  belongs_to :warehouse, :required => false
end

District.fixture {{
  :name => /\w{1,10}/.gen,
  :street1 => /\w{10,20}/.gen,
  :street2 => /\w{10,20}/.gen,
  :city => /\w{10,20}/.gen,
  :state => /\w{2}/.gen,
  :zip => /\w{9}/.gen,
  :tax => (/0\.\d{4}/.gen).to_f,
  :ytd => (/\d{0,10}\.\d{2}/.gen).to_f
}}