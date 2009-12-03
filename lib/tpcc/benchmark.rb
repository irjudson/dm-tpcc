module DataMapper
 module TPCC
   def self.benchmark
      puts "Benchmarks not implemented yet."
      bm = Benchmark.new
      
      bm.new_order
      bm.payment
      bm.order_status
      bm.delivery
      bm.stock_level
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
     
     def new_order
       # Standard warehouse & district selections
       warehouse = Warehouse.first
       district = District.first(:offset => rand(warehouse.districts.count))
       customer = district.customers.first(:offset => rand(district.customers.count))
       num_items = rand(11)+5 
       
       cost = 0
       order = Order.new(:created => Time.now, :line_count => num_items, :all_local => 1, :new_orders => [NewOrder.new] )

       num_items.times { |row|
         item = Item.first(:offset => rand(Item.count))
         quantity = rand(10)+1

         cost += quantity * item.price
         
         stock = item.stocks.first(:warehouse => warehouse)
         if stock.quantity - quantity > 10
           stock.quantity = stock.quantity - quantity
         else
           stock.quantity = (stock.quantity - quantity) + 91
         end
         stock.ytd += quantity
         stock.order_count += 1
         
         line_item = OrderLine.new(:number => row, :supply_warehouse_id => warehouse.id, :quantity => quantity)
         order.order_lines << line_item
       }
       
       total_cost = cost * (1 - customer.discount) * ( 1 + warehouse.tax + district.tax)
     end
     
     def payment
       # Standard warehouse & district selections
       warehouse = Warehouse.first
       district = District.first(:offset => rand(warehouse.districts.count))
       
       amount = (rand * 4999.00) + 1.0
       payment_date = Time.now
       
       warehouse.ytd += amount
       district.ytd += amount
     end
     
     def order_status
       # Standard warehouse & district selections
       warehouse = Warehouse.first
       district = District.first(:offset => rand(warehouse.districts.count))
       
       # 60% by last name, 40% by customer id
       #customer = rand(10)+1 <= 6 ? Customer.first : Customer.get(DataMapper::TPCC::random_customer_id)
       customer = district.customers.first(:offset => rand(district.customers.count))
       
       # Get the order for the customer
       order = customer.orders.first(:order => [ :created.desc ])
             
       # For each line in the order emit the necessary information
       order.order_lines.each do |line|
         puts "#{line.item_code} #{line.supply_warehouse_id} #{line.quantity} #{line.amount} #{line.delivery_date}"
       end
     end
     
     def delivery
       # Standard warehouse selections
       warehouse = Warehouse.first
       carrier = rand(10)+1
       delivery_date = Time.now       
     end
     
     def stock_level
       # Standard warehouse & district selections
       warehouse = Warehouse.first   
       district = District.first(:offset => rand(warehouse.districts.count))

       below_stock_threshold = 0    
       threshold = rand(11)+10    
       
       district.customers.orders.all(:limit => 20, :order => [ :created.desc ]).order_lines.each do |item|
         if item.stock.quantity < threshold
           below_stock_threshold += 1
         end
       end
       below_stock_threshold
     end
   end
 end
end