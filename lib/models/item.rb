class Item
  include DataMapper::Resource

  storage_names[:default] = "item"

  property :i_id,     Serial
  property :i_im_id,  Integer
  property :i_name,   String, :length => 24
  property :i_price,  Float
  property :i_data,   String, :length => 50

  has n, :stocks, :child_key => [ :s_id ], :parent_key => [ :i_id ]
end

if DataMapper.constants.include?(:Sweatshop)
  Item.fixture {{
    :i_im_id  => DataMapper::TPCC::random(1,10000),
    :i_name   => /\w{14,24}/.gen,
    :i_price  => DataMapper::TPCC::random(1.0,100.0),
    :i_data   => DataMapper::TPCC::random_string(26, 50, encode="ORIGINAL", percent=10)
    }}
end