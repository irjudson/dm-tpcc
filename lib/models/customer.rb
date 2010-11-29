class Customer
  include DataMapper::Resource

  storage_names[:default] = "customer"

  property :c_id, Serial
  property :c_first, String, :length => 16
  property :c_middle, String, :length => 2
  property :c_last, String, :length => 16
  property :c_street_1, String, :length => 20
  property :c_street_2, String, :length => 20
  property :c_city, String, :length => 20
  property :c_state, String, :length => 2
  property :c_zip, String, :length => 9
  property :c_phone, String, :length => 16
  property :c_since, DateTime
  property :c_credit, String, :length => 2 # GC = Good Credit, BC = Bad Credit
  property :c_credit_lim, Float
  property :c_discount, Float
  property :c_balance, Float
  property :c_ytd_payment, Float
  property :c_payment_cnt, Integer
  property :c_delivery_cnt, Integer
  property :c_data, String,  :length => 500

  has n, :orders,     :child_key => [ :o_c_id ], :parent_key => [ :c_id ]
  has n, :histories,  :child_key => [ :h_c_id ], :parent_key => [ :c_id ]

  # For relationships
  property :c_d_id, Integer, :key => true
  property :c_w_id, Integer, :key => true
  belongs_to :district,   :parent_key => [ :d_id ], :child_key => [ :c_d_id ]
  belongs_to :warehouse,  :parent_key => [ :w_id ], :child_key => [ :c_w_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  Customer.fixture {{
    :c_first        => Randgen.first_name,
    :c_middle       => "OE",
    :c_last         => DataMapper::TPCC::random_last_name,
    :c_street_1     => /\w{10,20}/.gen,
    :c_street_2     => /\w{10,20}/.gen,
    :c_city         => /\w{10,20}/.gen,
    :c_state        => /\w{2}/.gen,
    :c_zip          => /\w{9}/.gen,
    :c_phone        => /\w{16}/.gen,
    :c_since        => DateTime.now,
    :c_credit       => DataMapper::TPCC::random_credit,
    :c_credit_lim   => 50000.00,
    :c_discount     => DataMapper::TPCC::random(0,5000)/10000.00,
    :c_balance      => -10.00,
    :c_ytd_payment  => 10.00,
    :c_payment_cnt  => 1,
    :c_delivery_cnt => 0,
    :c_data         => DataMapper::TPCC::random_string(300,500)
    }}
end