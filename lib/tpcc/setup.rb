module DataMapper
  module TPCC
    def self.setup(*args)
      DataMapper.auto_migrate!(*args) if DataMapper.respond_to?(:auto_migrate!)
    end
    
    def self.init
      $last_name_parts = {
        0 => "BAR",
        1 => "OUGHT",
        2 => "ABLE",
        3 => "PRI",
        4 => "PRES",
        5 => "ESE",
        6 => "ANTI",
        7 => "CALLY",
        8 => "ATION",
        9 => "EING"
      }
      
      $c_id = DataMapper::TPCC::NURand(1023, 1, 3000)
      $c_last = DataMapper::TPCC::NURand(255, 0, 999)
      $i_id = DataMapper::TPCC::NURand(8191, 1, 100000)
      true
    end
  end
end