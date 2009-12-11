module DataMapper
  module TPCC
    class Benchmark
      #
      # There are five transactions that matter, this class implements them
      # as methods and has helper methods to capturing timing information and
      # format it for output.
      #
      attr_accessor :transaction
      attr_accessor :perf_hash

      def initialize
        self.transaction = DataMapper::Transaction.new(repository(:default))
        self.perf_hash = Hash.new
      end
      
      def run(filename="benchmark.csv", duration=10)
        outfile = File.open(filename, "w")
        outfile.write(["Timestamp", "transaction", "user", "system", "total", "real"].join(",")+"\n")
        stack = make_stack
        elapsed_time = 0
        while elapsed_time < duration
          stack.each do |card| 
            ex_time = ::Benchmark.measure { Warehouse.transaction { self.send(card) } }
            elapsed_time += ex_time.real
            fmt = "%10.6u, %10.6y, %10.6t"
            outfile.write("#{"%16s" % Time.now.to_f}, #{"%13s" % card.to_s}, #{ex_time.format(fmt)}, #{"%10.6f" % ex_time.real}\n")
          end
          stack.sort{ |a,b| rand(3)-1 }
        end
        outfile.close
      end
       
      def make_stack
        # 10 new_order
        # 10 payment
        # 1 order-status
        # 1 delivery
        # 1 stock-level
        cards = Array.new
        10.times { cards << :new_order }
        10.times { cards << :payment }
        cards << :order_status
        cards << :delivery
        cards << :stock_level
        cards.sort{ |a,b| rand(3)-1 }
      end

      def run_once
          puts "New Order:" ; self.new_order
          puts "Payment:"; self.payment
          puts "Order Status:"; self.order_status 
          puts "Delivery: "; self.delivery 
          puts "Stock Level: "; self.stock_level
      end

      def pick_customer(warehouse, district)
        customer = nil
        while customer.nil?
          # 60% by last name, 40% by customer id
          if DataMapper::TPCC::random(1,100) <= 60
            # last name
            customer = district.customers.first(:last => DataMapper::TPCC::random_last_name)
          else
            # id
            customer = district.customers.first(:offset => DataMapper::TPCC::random(0,district.customers.count-1))
          end
        end
        customer
      end

      ##
      # Performs a New Order transaction, per page 28, of TPC-C version 5.10.1
      #
      # @api public

      def new_order
        # Standard warehouse & district selections
        debugger
        warehouse = Warehouse.first(:offset => rand(Warehouse.count).to_i)   
#        district = warehouse.districts.first(:offset => rand(warehouse.districts.count))
        district = District.first(:warehouse_id => warehouse.id, :offset => rand(Districts.count)).
#        customer = district.customers.first(:offset => rand(district.customers.count))
        customer = district.customers.first(:offset => rand(district.customers.count))
        num_items = DataMapper::TPCC::random(5,15) 

        cost = 0
        order = Order.new(:created => Time.now, :line_count => num_items, :all_local => 1, :new_orders => [NewOrder.new] )
        district.next_order_number += 1
        num_items.times { |row|
          item = Item.get(DataMapper::TPCC::random_order_line_item_id)
          quantity = DataMapper::TPCC::random(1,10)

          cost += quantity * item.price

          stock = item.stocks.first(:warehouse => warehouse)
          if stock.quantity - quantity > 10
            stock.quantity = stock.quantity - quantity
          else
            stock.quantity = (stock.quantity - quantity) + 91
          end
          stock.ytd += quantity
          stock.order_count += 1
          stock.save

          line_item = OrderLine.new(:line_number => row, :supply_warehouse_id => warehouse.id, :quantity => quantity)
          order.order_lines << line_item
        }
        
        order.save
        
        total_cost = cost * (1 - customer.discount) * ( 1 + warehouse.tax + district.tax)
      end

      def payment
        # Standard warehouse & district selections
        warehouse = Warehouse.first(:offset => rand(Warehouse.count))   
        district = warehouse.districts.first(:offset => rand(warehouse.districts.count))

        customer = pick_customer(warehouse, district)

        amount = DataMapper::TPCC::random(1.00,5000.00)
        payment_date = Time.now

        warehouse.ytd += amount
        district.ytd += amount
        customer.balance -= amount
        customer.ytd_payments += amount
        customer.payment_count += 1
        if customer.credit == "BC"
          update = "#{customer.id} - #{customer.district.id} - #{customer.warehouse.id} - #{district.id} - #{warehouse.id} - #{amount}"
          customer.data = update + customer.data[update.length, customer.data.length - update.length]
        end
        customer.histories << History.new(:created => payment_date, :amount => amount, :data => "#{warehouse.name}    #{district.name}")
        customer.save
        warehouse.save
        district.save
      end

      def order_status
        # Standard warehouse & district selections
        warehouse = Warehouse.first(:offset => rand(Warehouse.count))   
        district = warehouse.districts.first(:offset => rand(warehouse.districts.count))

        customer = pick_customer(warehouse, district)

        # Get the order for the customer
        order = customer.orders.first(:order => [ :created.desc ])
        # For each line in the order emit the necessary information
        order.order_lines.each do |line|
          #$logger << "#{line.item_code} #{line.supply_warehouse_id} #{line.quantity} #{line.amount} #{line.delivery_date}"
        end
      end

      def delivery
        # Standard warehouse selections
        warehouse = Warehouse.first(:offset => rand(Warehouse.count))   
        carrier = DataMapper::TPCC::random(1,10)
        delivery_date = Time.now       

        warehouse.districts.each do |district|
          new_order = NewOrder.first(:district => district)
          unless new_order.nil? 
            order = new_order.order 
            new_order.destroy
            order.carrier = carrier
            amount = 0
            order.order_lines.each do |order_line|
              order_line.delivery_date = delivery_date
              amount += order_line.amount
            end
            order.save
            customer = order.customer
            customer.balance += amount
            customer.delivery_count += 1
            customer.save
          end
        end
      end

      def stock_level
        # Standard warehouse & district selections
        warehouse = Warehouse.first(:offset => rand(Warehouse.count))   
        district = warehouse.districts.first(:offset => rand(warehouse.districts.count))

        below_stock_threshold = 0    
        threshold = rand(11)+10    

        Order.all(:district => district, :limit => 20, :order => [ :created.desc ]).order_lines.each do |item|
          if item.stock.quantity < threshold
            below_stock_threshold += 1
          end
        end
        below_stock_threshold
      end
    end
  end
end
