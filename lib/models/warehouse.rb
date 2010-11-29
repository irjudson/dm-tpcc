class Warehouse
  include DataMapper::Resource

  storage_names[:default] = "warehouse"

  property :w_id, Serial
  property :w_name, String, :length => 10
  property :w_street_1, String, :length => 20
  property :w_street_2, String, :length => 20
  property :w_city, String, :length => 20
  property :w_state, String, :length => 2
  property :w_zip, String, :length => 9
  property :w_tax, Float
  property :w_ytd, Float

  has n, :districts,  :child_key => [ :d_w_id   ], :parent_key => [ :w_id ]
  has n, :stocks,     :child_key => [ :s_w_id   ], :parent_key => [ :w_id ]
  has n, :new_orders, :child_key => [ :no_w_id  ], :parent_key => [ :w_id ]
  has n, :customers,  :child_key => [ :c_w_id   ], :parent_key => [ :w_id ]
  has n, :histories,  :child_key => [ :h_w_id   ], :parent_key => [ :w_id ]
  has n, :orders,     :child_key => [ :o_w_id   ], :parent_key => [ :w_id ]
  has n, :order_lines,:child_key => [ :ol_w_id  ], :parent_key => [ :w_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  Warehouse.fixture {{
    :w_name     => /\w{6,10}/.gen,
    :w_street_1 => /\w{10,20}/.gen,
    :w_street_2 => /\w{10,20}/.gen,
    :w_city     => /\w{10,20}/.gen,
    :w_state    => /\w{2}/.gen,
    :w_zip      => /\d{4}11111/.gen,
    :w_tax      => DataMapper::TPCC::random(0,2000)/10000.0,
    :w_ytd      => 300000.00
    }}
  end