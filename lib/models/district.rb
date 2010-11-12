class District
  include DataMapper::Resource

  storage_names[:default] = "district"

  property :d_id, Serial
  property :d_name, String, :length => 10
  property :d_street_1, String, :length => 20
  property :d_street_2, String, :length => 20
  property :d_city, String, :length => 20
  property :d_state, String, :length => 2
  property :d_zip, String, :length => 9
  property :d_tax, Float
  property :d_ytd, Float
  property :d_next_o_id, Integer

  has n, :new_orders, :child_key => [ :no_d_id  ], :parent_key => [ :d_id ]
  has n, :customers,  :child_key => [ :c_d_id   ], :parent_key => [ :d_id ]
  has n, :histories,  :child_key => [ :h_d_id   ], :parent_key => [ :d_id ]
  has n, :orders,     :child_key => [ :o_d_id   ], :parent_key => [ :d_id ]
  has n, :order_lines,:child_key => [ :ol_d_id  ], :parent_key => [ :d_id ]

  # For relationship stuff
  property :d_w_id, Integer, :key => true
  belongs_to :warehouse, :parent_key => [ :w_id ], :child_key => [ :d_w_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  District.fixture {{
    :d_name         => /\w{6,10}/.gen,
    :d_street_1     => /\w{10,20}/.gen,
    :d_street_2     => /\w{10,20}/.gen,
    :d_city         => /\w{10,20}/.gen,
    :d_state        => /\w{2}/.gen,
    :d_zip          => /\d{4}11111/.gen,
    :d_tax          => DataMapper::TPCC::random(0,2000)/10000.0,
    :d_ytd          => 30000.00,
    :d_next_o_id    => 30001
    }}
end