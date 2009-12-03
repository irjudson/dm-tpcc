class Customer
  include DataMapper::Resource

  property :id, Serial
  property :first, String, :length => 16
  property :middle, String, :length => 2
  property :last, String, :length => 16
  property :street1, String, :length => 20
  property :street2, String, :length => 20
  property :city, String, :length => 20
  property :state, String, :length => 2
  property :zip, String, :length => 9
  property :phone, String, :length => 16
  property :since, DateTime
  property :credit, String, :length => 2 # GC = Good Credit, BC = Bad Credit
  property :credit_limit, Float
  property :discount, Float
  property :balance, Float
  property :ytd_payments, Float
  property :payment_count, Integer
  property :delivery_count, Integer
  property :data, String, :length => 500

  has n, :orders
  has n, :histories
  
  belongs_to :district, :required => false, :child_key => :district_id
  
  has 1, :warehouse, :through => :district
end

Customer.fixture {{
  :first => /\w{8,16}/.gen,
  :middle => "OE",
  :last => DataMapper::TPCC::random_last_name,
  :street1 => /\w{10,20}/.gen,
  :street2 => /\w{10,20}/.gen,
  :city => /\w{10,20}/.gen,
  :state => /\w{2}/.gen,
  :zip => /\d{4}11111/.gen,
  :phone => /\d{16}/.gen,
  :since => DateTime.now,
  :credit => /GC|BC/.gen,
  :credit_limit => 50000.00,
  :discount => DataMapper::TPCC::random(0,5000)/10000.00,
  :balance => -10.00,
  :ytd_payments => 10.00,
  :payment_count => 1, 
  :delivery_count => 0, 
  :data => /[:paragraph:]/.gen.slice(0, DataMapper::TPCC::random(300,500))
}}