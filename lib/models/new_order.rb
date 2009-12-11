class NewOrder
  include DataMapper::Resource

  property :id, Serial
  
  belongs_to :district, :required => false
  belongs_to :warehouse, :required => false
  belongs_to :order, :required => false
end

NewOrder.fixture {{ }}