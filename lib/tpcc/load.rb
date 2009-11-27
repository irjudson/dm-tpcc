require 'ruby-debug'

module DataMapper
  module TPCC
    #
    # This creates all the necessary data in the database tables to execute the TPC-C benchmark. 
    # This requires a set of data that is scaled by the number of warehouses in the database.
    # The scaling factors are taken from the specification of TPC-C, section 1.2.1.
    #
    def self.load(num_warehouses = 1)
      before = Time.now()      
      # 300000 for production
      (num_warehouses*30).of { OrderLine.make }
      duration = Time.now() - before
      puts "Created #{num_warehouses*300000} OrderLine Items in #{duration} seconds."

      before = Time.now()
      # 100000 for production
      (num_warehouses*10).of { Stock.make }
      duration = Time.now() - before
      puts "Created #{num_warehouses*100000} Stock Items in #{duration} seconds."
      
      before = Time.now()
      # 100000 for production
      10.of { Item.gen }
      duration = Time.now() - before
      puts "Created #{100000} Item Items in #{duration} seconds."
      
      before = Time.now()
      num_warehouses.of { Warehouse.gen }
      duration = Time.now() - before
      puts "Created #{num_warehouses} Warehouse Items in #{duration} seconds."  
    end
  end
end