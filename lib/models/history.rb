class History
  include DataMapper::Resource

  property :id, Serial
  property :created, DateTime
  property :amount, Float
  property :data, String, :length => 24
  
  belongs_to :customer, :required => false
  
  has 1, :district, :through => :customer
  has 1, :warehouse, :through => :district
end

History.fixture {{
  :created => DateTime.now,
  :amount => (/\d{6}\.\d{2}/.gen).to_f,
  :data => /[:sentence:]/.gen[1..24]
}}