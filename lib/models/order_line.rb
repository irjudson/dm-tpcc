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
  :number => /\d{8}/.gen,
  :item_code => /\d{2}/.gen,
  :supply_warehouse_id => /\d{4}/.gen,
  :delivery_date => DateTime.now,
  :quantity => /\d{2}/.gen,
  :amount => /\d{6}\.\d{2}/.gen,
  :district_information => /[:sentence:]/.gen[1..24],
}}