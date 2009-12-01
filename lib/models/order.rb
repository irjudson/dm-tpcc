class Order
  include DataMapper::Resource

  property :id, Serial
  property :created, DateTime
  property :carrier, Integer
  property :line_count, Integer
  property :all_local, Integer
  
  has n, :new_orders
  has n, :order_lines
  
  belongs_to :customer, :required => false
  
  has 1, :district, :through => :customer
  has 1, :warehouse, :through => :district
end

Order.fixture {{
  :carrier => /\d/.gen,
  :line_count => /\d{2}/.gen,
  :all_local => /\d{1}/.gen,
  :created => DateTime.now
}}