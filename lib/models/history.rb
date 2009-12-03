class History
  include DataMapper::Resource

  property :id, Serial
  property :created, DateTime
  property :amount, Float
  property :data, String, :length => 24
  
  belongs_to :customer
  
  has 1, :district, :through => :customer
  has 1, :warehouse, :through => :district
end

History.fixture {{
  :created => DateTime.now,
  :amount => 10.00,
  :data => DataMapper::TPCC::random_string(12, 24)
}}