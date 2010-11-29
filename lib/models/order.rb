class Order
  include DataMapper::Resource

  #TPCCUVa seems to use orderr instead of order (?)
  storage_names[:default]              = "orderr"

  property :o_id, Serial
  property :o_entry_d, DateTime
  property :o_carrier_id, Integer
  property :o_ol_cnt, Integer
  property :o_all_local, Integer

  has n, :new_orders,  :child_key      => [ :no_id ], :parent_key => [ :o_id ]
  has n, :order_lines, :child_key      => [ :ol_id ], :parent_key => [ :o_id ]

  # Relationship properties
  property :o_c_id, Integer, :required => false
  property :o_d_id, Integer, :required => false
  property :o_w_id, Integer, :required => false
  belongs_to :customer, :parent_key    => [ :c_id ], :child_key => [ :o_c_id ]
  belongs_to :district, :parent_key    => [ :d_id ], :child_key => [ :o_d_id ]
  belongs_to :warehouse,:parent_key    => [ :w_id ], :child_key => [ :o_w_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  Order.fixture {{
    :o_carrier_id                      => DataMapper::TPCC::random_carrier_id,
    :o_ol_count                        => DataMapper::TPCC::random(5,15),
    :o_all_local                       => 1,
    :o_entry_d                         => DateTime.now,
    }}
end
