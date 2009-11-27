module DataMapper
  module TPCC
    def self.setup(*args)
      DataMapper.auto_migrate!(*args) if DataMapper.respond_to?(:auto_migrate!)
    end
  end
end