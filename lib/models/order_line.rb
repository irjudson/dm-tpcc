class OrderLine
  include DataMapper::Resource

  storage_names[:default]                     = "order_line"

  property :ol_number,        Integer, :key   => true
  property :ol_i_id,          Integer
  property :ol_supply_w_id,   Integer
  property :ol_delivery_d,    DateTime
  property :ol_quantity,      Integer
  property :ol_amount,        Float
  property :ol_dist_info,     String, :length => 24

  # Relationship properties
  property :ol_o_id, Integer, :key            => true
  property :ol_d_id, Integer, :key            => true
  property :ol_w_id, Integer, :key            => true
  belongs_to :order,    :parent_key           => [ :o_id ], :child_key => [ :ol_o_id ]
  belongs_to :district, :parent_key           => [ :d_id ], :child_key => [ :ol_d_id ]
  belongs_to :warehouse,:parent_key           => [ :w_id ], :child_key => [ :ol_w_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  OrderLine.fixture {{
    :ol_number                                => /\d{1,8}/.gen,
    :ol_i_id                                  => DataMapper::TPCC::random(0,100000),
    :ol_supply_w_id                           => 1,
    :ol_delivery_d                            => DateTime.now,
    :ol_quantity                              => 5,
    :ol_amount                                => DataMapper::TPCC::random(0.01, 9999.99),
    :ol_district_info                         => /\w{24}/.gen
    }}
end
