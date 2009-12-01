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
       warehouse = Warehouse.first
       district = District.first(:offset => rand(warehouse.districts.count))
       customer = district.customers.first(:offset => rand(district.customers.count))
       num_items = rand(11)+5 
       
       # warehouse.tax, district.tax, 
       # customer.discount, customer.last_name, customer.credit
      
       order = Order.new(:created => Time.now, :line_count => num_items, :all_local => 1, :new_orders => [NewOrder.new] )

       num_items.times {
         item = Item.first(:offset => rand(Item.count))
         quantity = rand(10)+1
         # item.price, item.name, item.desc
         
       }
       
       raise NotImplementedError
     end
     
     def self.payment_transaction
       raise NotImplementedError
     end
     
     def order_status_transaction
       raise NotImplementedError
     end
     
     def delivery_transaction
       warehouse = Warehouse.first
       carrier = rand(10)+1
       delivery_date = Time.now
       
       raise NotImplementedError
     end
     
     def stock_level_transaction
       below_stock_threshold = 0    
       threshold = rand(11)+10    
       warehouse = Warehouse.first   
       district = District.first(:offset => rand(wareshouse.districts.count))
       
       distrct.orders.all(:limit => 20, :order => [ :created.desc ]).items.each do |item|
         item_quantity = item.stocks.inject(0) { |sum, item| sum += item.quantity }
         if item_quantity < threshold
           below_stock_threshold += 1
         end
       end
       below_stock_threshold
     end
   end
 end
end