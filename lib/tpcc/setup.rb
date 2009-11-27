module DataMapper
  module TPCC
    def self.setup(repository = :default)
      DataMapper.auto_migrate! if DataMapper.respond_to?(:auto_migrate!)
    end
  end
end