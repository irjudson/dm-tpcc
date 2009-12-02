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
  property :data, String,  :length => 500

  has n, :orders
  has n, :histories
  
  belongs_to :district, :required => false
  
  has 1, :warehouse, :through => :district
end

Customer.fixture {{
  :first => Randgen.first_name,
  :middle => /\w{2}/.gen,
  :last => DataMapper::TPCC::random_last_name,
  :street1 => /\w{10,20}/.gen,
  :street2 => /\w{10,20}/.gen,
  :city => /\w{10,20}/.gen,
  :state => /\w{2}/.gen,
  :zip => /\w{9}/.gen,
  :phone => /\w{16}/.gen,
  :since => DateTime.now,
  :credit => /GC|BC/.gen,
  :credit_limit => (/\d{0,10}\.\d{2}/.gen).to_f,
  :discount => (/0\.\d{4}/.gen).to_f,
  :balance => (/\d{0,10}\.\d{2}/.gen).to_f,
  :ytd_payments => (/\d{0,10}\.\d{2}/.gen).to_f,
  :payment_count => /\d{0,4}/.gen,
  :delivery_count => /\d{0,4}/.gen,
  :data => /[:sentence:]/.gen[1..500]
}}