module DataMapper
  module TPCC
    #
    # This creates all the necessary data in the database tables to execute the TPC-C benchmark. 
    # This requires a set of data that is scaled by the number of warehouses in the database.
    # The scaling factors are taken from the specification of TPC-C, section 1.2.1.
    #
    def self.load(num_warehouses = 1)

      GC.start()
      
      make_history(num_warehouses)
      
      GC.start()
      
      duration = ::Benchmark.realtime { 
        DataMapper::Repository.adapters[:default].execute("lock tables new_orders write;")
        (num_warehouses*9000).of { NewOrder.gen } 
        DataMapper::Repository.adapters[:default].execute("unlock tables;")            
      }
      
      puts "Created #{num_warehouses*9000} NewOrder instances in #{"%.3f" % duration} seconds."

      GC.start()
      
      return

      duration = ::Benchmark.realtime {
        DataMapper::Repository.adapters[:default].execute("lock tables order_lines write;")
        3.times {
          (num_warehouses*100000).of { OrderLine.gen }
        }
        DataMapper::Repository.adapters[:default].execute("unlock tables;")                    
      }
      puts "Created #{num_warehouses*100000} OrderLine instances in #{"%.3f" % duration} seconds."        

      duration = ::Benchmark.realtime { 
        DataMapper::Repository.adapters[:default].execute("lock tables customers write;")
        DataMapper::Repository.adapters[:default].execute("lock tables stocks write;")
        DataMapper::Repository.adapters[:default].execute("lock tables orders write;")
        num_warehouses.of { Warehouse.gen } 
        DataMapper::Repository.adapters[:default].execute("unlock tables;")                    
      }
      puts "Created #{num_warehouses} Warehouse instances in #{"%.3f" % duration} seconds."

      duration = ::Benchmark.realtime { 
        DataMapper::Repository.adapters[:default].execute("lock tables items write;")
        100000.of { Item.gen } 
        DataMapper::Repository.adapters[:default].execute("unlock tables;")                    
      }
      puts "Created #{100000} Item instances in #{"%.3f" % duration} seconds."
    end
    
    def self.make_history(num_warehouses)
      duration = ::Benchmark.realtime { 
          DataMapper::Repository.adapters[:default].execute("lock tables histories write;")
          (num_warehouses*30000).of { History.gen } 
          DataMapper::Repository.adapters[:default].execute("unlock tables;")      
      }
      puts "Created #{num_warehouses*30000} History instances in #{"%.3f" % duration} seconds."
    end
  end
end