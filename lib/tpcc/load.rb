module DataMapper
  module TPCC
    #
    # This creates all the necessary data in the database tables to execute the TPC-C benchmark. 
    # This requires a set of data that is scaled by the number of warehouses in the database.
    # The scaling factors are taken from the specification of TPC-C, section 1.2.1.
    #
    def self.load(num_warehouses = 1)

      scale = {
        :warehouse => num_warehouses,
        :district => num_warehouses * 10,
        :customer => num_warehouses * 30000,
        :order => num_warehouses * 30000,
        :history => num_warehouses * 30000,
        :new_order => num_warehouses * 9000,
        :order_line => num_warehouses * 300000,
        :stock => num_warehouses * 100000,
        :item => 100000
      }

      total_time = ::Benchmark.realtime {
        make_history(scale[:history])
      
        make_new_orders(scale[:new_order])
    
        make_order_lines(scale[:order_line])

        make_warehouse_tree(scale[:warehouses])
      
        make_items(scale[:item])
      }
      
      puts "Created Initial Dataset in #{total_time} seconds."
    end
    
    def self.make_thing(number, klass)
      duration = ::Benchmark.realtime { self.transaction.commit { number.time { klass.gen } } }
      puts "Created #{number} #{klass.name} instances in #{"%.3f" % duration} seconds."
    end
    
    def self.make_history(number)
      transaction = DataMapper::Transaction.new(repository(:default))
      duration = ::Benchmark.realtime { transaction.commit { number.times { History.gen } } }
      puts "Created #{number} History instances in #{"%.3f" % duration} seconds."
    end
    
    def self.make_new_orders(number)
      transaction = DataMapper::Transaction.new(repository(:default))
      duration = ::Benchmark.realtime { transaction.commit { number.times { NewOrder.gen } } }      
      puts "Created #{number} NewOrder instances in #{"%.3f" % duration} seconds."
    end
    
    def self.make_order_lines(number)
      transaction = DataMapper::Transaction.new(repository(:default))
      duration = ::Benchmark.realtime {transaction.commit { number.times { OrderLine.gen } } }
      puts "Created #{number} OrderLine instances in #{"%.3f" % duration} seconds."        
    end
    
    def self.make_warehouse_tree(number)
      transaction = DataMapper::Transaction.new(repository(:default))
      duration = ::Benchmark.realtime { transaction.commit { number.times { Warehouse.gen } } }
      puts "Created #{number} Warehouse instances in #{"%.3f" % duration} seconds."
    end
    
    def self.make_items(number)
      transaction = DataMapper::Transaction.new(repository(:default))
      duration = ::Benchmark.realtime { transaction.commit { number.times { Item.gen } } }
      puts "Created #{number} Item instances in #{"%.3f" % duration} seconds."
    end
  end

  # DM-Sweatshop is evil and tries to keep a reference to every object allocated.
  class Sweatshop
    class << self
      attr_accessor :object_count
      attr_accessor :object_threshold
    end
    
     self.record_map = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] = 0}}
     self.object_count = 0
     self.object_threshold = 25000
     
     def self.record(klass, name, instance)
       # self.record_map[klass][name.to_sym] << instance
       self.record_map[klass][name.to_sym] += 1

       self.object_count += 1
       if self.object_count > self.object_threshold
         GC.start
         self.object_count = 0
       end
       
       instance
     end

     def self.pick(klass, name)
       # self.record_map[klass][name.to_sym].pick || raise(NoFixtureExist, "no #{name} context fixtures have been generated for the #{klass} class")
       offset = (rand * self.record_map[klass][name.to_sym]).to_i + 1
       klass.first(:offset => offset) || raise(NoFixtureExist, "no #{name} context fixtures have been generated for the #{klass} class")
     end

   end
end

