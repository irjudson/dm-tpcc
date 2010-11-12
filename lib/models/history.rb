class History
  include DataMapper::Resource

  storage_names[:default] = "history"

  property :h_date,   DateTime
  property :h_amount, Float
  property :h_data,   String, :length => 24

  # Through Customer
  has 1, :h_c_d_id, { :through => :customer, :parent_key => [ :c_d_id ] }
  has 1, :h_c_w_id, { :through => :customer, :parent_key => [ :c_w_id ] }

  # Relationship properties
  property :h_c_id, Integer
  property :h_d_id, Integer
  property :h_w_id, Integer
  belongs_to :customer, :parent_key => [ :c_id ], :child_key => [ :h_c_id ]
  belongs_to :district, :parent_key => [ :d_id ], :child_key => [ :h_d_id ]
  belongs_to :warehouse,:parent_key => [ :w_id ], :child_key => [ :h_w_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  History.fixture {{
    :h_date   => DateTime.now,
    :h_amount => 10.00,
    :h_data   => DataMapper::TPCC::random_string(12, 24)
    }}
end