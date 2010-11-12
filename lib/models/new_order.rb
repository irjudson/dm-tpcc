class NewOrder
  include DataMapper::Resource

  storage_names[:default] = "new_order"

  # Relationship Properties
  property :no_d_id, Integer, :key => true
  property :no_w_id, Integer, :key => true
  property :no_o_id, Integer, :key => true

  belongs_to :district, :parent_key => [ :d_id ], :child_key => [ :no_d_id ]
  belongs_to :warehouse,:parent_key => [ :w_id ], :child_key => [ :no_w_id ]
  belongs_to :order,    :parent_key => [ :o_id ], :child_key => [ :no_o_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  NewOrder.fixture {{ }}
end