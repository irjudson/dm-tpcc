class NewOrder
  include DataMapper::Resource

  property :id, Serial
  
  belongs_to :order, :required => false
  
  has 1, :district, :through => :order
  has 1, :warehouse, :through => :district
end

NewOrder.fixture {{
  
}}