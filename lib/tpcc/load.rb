module DataMapper
  module TPCC
    #
    # This creates all the necessary data in the database tables to execute the TPC-C benchmark. 
    # This requires a set of data that is scaled by the number of warehouses in the database.
    # The scaling factors are taken from the specification of TPC-C, section 1.2.1.
    #
    @@order_ids = []
    def self.load(num_warehouses = 1)
      transaction = DataMapper::Transaction.new(repository(:default))
      total_time = ::Benchmark.realtime do
        num_warehouses.times do
          warehouse_id =  Warehouse.gen.id 
          
          10.times do
            district_id = District.gen(:warehouse_id => warehouse_id).id
            self.gen_customers(district_id, warehouse_id)
          end
          
          self.gen_stock(warehouse_id)
        end
      end
      puts "Created Initial Dataset in #{total_time} seconds."
    end
    
    def self.gen_customers(district_id, warehouse_id)
      transaction = DataMapper::Transaction.new(repository(:default))
      duration = ::Benchmark.realtime do
        transaction.commit do
          3000.times do
            customer_id = Customer.gen(:district_id => district_id).id
            self.gen_history(customer_id, district_id, warehouse_id)
            self.gen_order(customer_id, district_id, warehouse_id)
          end
        end
      end
      puts "Created 3000 Customers in #{"%.3f" % duration} seconds."
    end
    
    def self.gen_history(customer_id, district_id, warehouse_id)
      1.times do
        history_id = History.gen(:customer_id => customer_id)
      end
    end
    
    def self.gen_order(customer_id, district_id, warehouse_id)
      1.times do
        order_id = Order.gen(:customer_id => customer_id).id
        @@order_ids << order_id
        NewOrder.gen(:order_id => order_id) if((rand() * 2).to_i == 1)
      end
    end
    
    def self.gen_stock(warehouse_id)
      (100000/2500).times do
        transaction = DataMapper::Transaction.new(repository(:default))
        duration = ::Benchmark.realtime do
          transaction.commit do
            2500.times do
              item_id = Item.gen.id
              stock_id = Stock.gen(:warehouse_id => warehouse_id, :item_id => item_id).id
              self.gen_order_line(stock_id)
            end
          end
        end
        puts "Created 2500 Stocks in #{"%.3f" % duration} seconds."
      end
    end
    
    def self.gen_order_line(stock_id)
      3.times do
        next_order_id = self.next_order_id
        OrderLine.gen(:stock_id => stock_id, :order_id => next_order_id)
      end
    end
    
    def self.next_order_id
      @@current_count ||= 0
      @@current_id = @@order_ids.pop if( (@@current_count % 10) == 0 )
      @@current_count += 1
      return @@current_id
    end
    

  end

  # DM-Sweatshop is evil and tries to keep a reference to every object allocated.
  class Sweatshop
    class << self
      attr_accessor :object_count
      attr_accessor :object_threshold
    end
    
     self.record_map = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] = []}}
     self.object_count = 0
     self.object_threshold = 25000
     
     def self.record(klass, name, instance)
       # self.record_map[klass][name.to_sym] << instance
       self.record_map[klass][name.to_sym].push instance.id

       self.object_count += 1
       if self.object_count > self.object_threshold
         GC.start
         self.object_count = 0
       end
       
       instance
     end

     def self.pick(klass, name)
       # self.record_map[klass][name.to_sym].pick || raise(NoFixtureExist, "no #{name} context fixtures have been generated for the #{klass} class")
       # offset = (rand * self.record_map[klass][name.to_sym]).to_i + 1
       # 
       id = self.record_map[klass][name.to_sym].pop
       klass.get(id) || raise(NoFixtureExist, "no #{name} context fixtures have been generated for the #{klass} class")
     end

   end
end

