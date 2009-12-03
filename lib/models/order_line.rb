class OrderLine
  include DataMapper::Resource

  property :id, Serial
  property :number, Integer
  property :item_code, Integer
  property :supply_warehouse_id, Integer
  property :delivery_date, DateTime
  property :quantity, Integer
  property :amount, Float
  property :district_information, String, :length => 24
  
  belongs_to :stock, :required => false
  belongs_to :order, :required => false
  
  has 1, :district, :through => :order
  has 1, :warehouse, :through => :district
end

OrderLine.fixture {{
  :number => /\d{1,8}/.gen,
  :item_code => DataMapper::TPCC::random(0,100000),
  :supply_warehouse_id => 1,
  :delivery_date => DateTime.now,
  :quantity => 5,
  :amount => 0.0,
  :district_information => /\w{24}/.gen
}}