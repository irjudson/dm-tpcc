class History
  include DataMapper::Resource

  property :id, Serial
  property :created, DateTime
  property :amount, Float
  property :data, String, :length => 24
  
  belongs_to :customer
  belongs_to :district
  belongs_to :warehouse
end

History.fixture {{
  :created => DateTime.now,
  :amount => 10.00,
  :data => DataMapper::TPCC::random_string(12, 24)
}}