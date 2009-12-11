class OrderLine
  include DataMapper::Resource

  property :id, Serial
  property :line_number, Integer
  property :item_code, Integer
  property :supply_warehouse_id, Integer
  property :delivery_date, DateTime
  property :quantity, Integer
  property :amount, Float
  property :district_information, String, :length => 24
  
  belongs_to :stock, :required => false
  belongs_to :order, :required => false
  belongs_to :district, :required => false
  belongs_to :warehouse, :required => false
end

OrderLine.fixture {{
  :line_number => /\d{1,8}/.gen,
  :item_code => DataMapper::TPCC::random(0,100000),
  :supply_warehouse_id => 1,
  :delivery_date => DateTime.now,
  :quantity => 5,
  :amount => DataMapper::TPCC::random(0.01, 9999.99),
  :district_information => /\w{24}/.gen
}}