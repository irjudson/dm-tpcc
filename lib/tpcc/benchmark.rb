module DataMapper
 module TPCC
   def self.benchmark
      puts "Benchmarks not implemented yet."
      bm = Benchmark.new
   end
   
   class Benchmark
     #
     # There are five transactions that matter, this class implements them
     # as methods and has helper methods to capturing timing information and
     # format it for output.
     #
     attr_accessor :transaction
     
     def initialize
       self.transaction = DataMapper::Transaction.new(repository(:default))
     end
     
     def self.new_order_transaction
       raise NotImplementedError
     end
     
     def self.payment_transaction
       raise NotImplementedError
     end
     
     def order_status_transaction
       raise NotImplementedError
     end
     
     def delivery_transaction
       raise NotImplementedError
     end
     
     def stock_level_transaction
       # Select a threshold randomly between 10 and 20
       # For a given warehouse and a given district
       # take the all items for the last 20 orders
       # for each item check to see if the # of items in stock is < threshold 
       # return the number of items that have quantities below threshold
     end
   end
 end
end