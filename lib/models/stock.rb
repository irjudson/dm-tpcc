class Stock
  include DataMapper::Resource

  storage_names[:default] = "stock"

  property :s_quantity, Integer
  property :s_dist_01, String, :length => 24
  property :s_dist_02, String, :length => 24
  property :s_dist_03, String, :length => 24
  property :s_dist_04, String, :length => 24
  property :s_dist_05, String, :length => 24
  property :s_dist_06, String, :length => 24
  property :s_dist_07, String, :length => 24
  property :s_dist_08, String, :length => 24
  property :s_dist_09, String, :length => 24
  property :s_dist_10, String, :length => 24
  property :s_ytd, Integer
  property :s_order_cnt, Integer
  property :s_remote_cnt, Integer
  property :s_data, String, :length => 50

  has n, :order_lines, :child_key => [ :ol_id ]

  # Relationship props
  property :s_w_id, Integer, :key => true
  property :s_i_id, Integer, :key => true
  belongs_to :warehouse,  :parent_key => [ :w_id ], :child_key => [ :s_w_id ]
  belongs_to :item,       :parent_key => [ :i_id ], :child_key => [ :s_i_id ]
end

if DataMapper.constants.include?(:Sweatshop)
Stock.fixture {{
  :s_quantity   => DataMapper::TPCC::random(10,100),
  :s_dist_01    => /\w{24}/.gen,
  :s_dist_02    => /\w{24}/.gen,
  :s_dist_03    => /\w{24}/.gen,
  :s_dist_04    => /\w{24}/.gen,
  :s_dist_05    => /\w{24}/.gen,
  :s_dist_06    => /\w{24}/.gen,
  :s_dist_07    => /\w{24}/.gen,
  :s_dist_08    => /\w{24}/.gen,
  :s_dist_09    => /\w{24}/.gen,
  :s_dist_10    => /\w{24}/.gen,
  :s_ytd        => 0,
  :s_order_cnt  => 0,
  :s_remote_cnt => 0,
  :s_data       => DataMapper::TPCC::random_string(26,50,"ORIGINAL",10)
}}
end