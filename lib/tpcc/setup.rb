module DataMapper
  module TPCC
    def self.setup(*args)
      DataMapper.auto_migrate!(*args) if DataMapper.respond_to?(:auto_migrate!)
    end
    
    def self.init
      $c_id = DataMapper::TPCC::NURand(1023, 1, 3000)
      $c_last = DataMapper::TPCC::NURand(255, 0, 999)
      $i_id = DataMapper::TPCC::NURand(8191, 1, 100000)
      $last_names = 1000.of { Randgen.last_name }
      true
    end
  end
end