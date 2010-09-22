module DataMapper
  module TPCC
    #
    # This method loads the contents of saved data from the files in
    # the data directory.  This is much faster than regenerating the
    # data each time, but requires the adapter to be able to execute
    # SQL queries to accept the bulk insert.
    #
    def self.load
      adapter = DataMapper.repository(:default).adapter
      total_time = ::Benchmark.realtime do
        DataMapper::Model.descendants.each do |model|
          table_name = model.storage_name
          duration = ::Benchmark.realtime do
            File.open("#{$data_directory}/#{table_name}.yml") do |fixture|
              YAML.each_document(fixture) do |ydoc|
                ydoc.each do |row|
                  model.create(row[1])
                end
              end
            end
          end
          puts "Loaded #{model.count} #{table_name} items in #{"%.3f" % duration} seconds."
        end
      end
      puts "Loaded Dataset in #{total_time} seconds"
      true
    end

    #
    # This saves the contents of all the TPC-C tables into yaml files
    # in the data directory.  These files can then be loaded by
    # subsequent tests, rather than regenerating the content which can
    # be a lengthy process.
    #
    def self.save
      adapter = DataMapper.repository(:default).adapter
      sql = "SELECT * FROM %s ORDER BY id LIMIT %s OFFSET %s"
      total_time = ::Benchmark.realtime do
        DataMapper::Model.descendants.each do |model|
          i = "0000000"
          table_name = model.storage_name
          total = model.count
          duration = ::Benchmark.realtime do
            current_offset = 0
            limit = 3000
            File.open("#{$datadir}/#{table_name}.yml", 'w+') do |f|
              while(current_offset < total)
                data = adapter.select(sql % [table_name, limit, current_offset])
                yaml_string = data.inject({}) { |hash, record|
                  tmp_hash = {}
                  record.each_pair{|key,value| tmp_hash[key] = value}
                  hash["#{table_name}_#{i.succ!}"] = tmp_hash
                  hash
                  }.to_yaml

                  f.write(yaml_string) # remove the --- from the YAMLized hash.
                  current_offset += limit
              end
            end
          end
          puts "Saved #{total} #{table_name} items in #{"%.3f" % duration} seconds."
        end
      end
      puts "Saved Dataset in #{total_time} seconds"
      true
    end

    #
    # This creates all the necessary data in the database tables to
    # execute the TPC-C benchmark.  This requires a set of data that
    # is scaled by the number of warehouses in the database.  The
    # scaling factors are taken from the specification of TPC-C,
    # section 1.2.1.
    #

    @@order_ids = []

    def self.generate(num_warehouses = 1)
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
      duration = ::Benchmark.realtime do
        3000.times do
          customer_id = Customer.gen(:district_id => district_id).id
          self.gen_history(customer_id, district_id, warehouse_id)
          self.gen_order(customer_id, district_id, warehouse_id)
        end
      end
      puts "Created 3000 Customers in #{"%.3f" % duration} seconds."
    end

    def self.gen_history(customer_id, district_id, warehouse_id)
      1.times do
        history_id = History.gen(:district_id => district_id,
                                 :warehouse_id => warehouse_id,
                                 :customer_id => customer_id)
      end
    end

    def self.gen_order(customer_id, district_id, warehouse_id)
      if @@order_ids.length <= 2100
        order_id = Order.gen(:district_id => district_id,
                             :warehouse_id => warehouse_id,
                             :customer_id => customer_id).id
      else
        order_id = Order.gen(:district_id => district_id,
                             :warehouse_id => warehouse_id,
                             :customer_id => customer_id,
                             :carrier => nil).id
      end
      @@order_ids << [order_id, district_id, warehouse_id]
      NewOrder.gen(:warehouse_id => warehouse_id,
                   :district_id => district_id,
                   :order_id => order_id) if((rand() * 2).to_i == 1)
    end

    def self.gen_stock(warehouse_id)
      (100000/2500).times do
        duration = ::Benchmark.realtime do
          2500.times do
            item_id = Item.gen.id
            stock_id = Stock.gen(:warehouse_id => warehouse_id,
                                 :item_id => item_id).id
            self.gen_order_line(stock_id)
          end
        end
        puts "Created 2500 Stocks in #{"%.3f" % duration} seconds."
      end
    end

    def self.gen_order_line(stock_id)
      3.times do
        next_order_id, district_id, warehouse_id = self.next_order_id
        if next_order_id <= 2100
          OrderLine.gen(:district_id => district_id, :warehouse_id => warehouse_id, :stock_id => stock_id, :order_id => next_order_id, :amount => 0.0)
        else
          OrderLine.gen(:district_id => district_id, :warehouse_id => warehouse_id, :stock_id => stock_id, :order_id => next_order_id)
        end
      end
    end

    def self.next_order_id
      @@current_count ||= 0
      @@current_id, @@district, @@warehouse = @@order_ids.pop if( (@@current_count % 10) == 0 )
      @@current_count += 1
      return @@current_id, @@district, @@warehouse
    end

    def self.random(min, max)
      rand((max+1)-min) + min
    end

    def self.NURand(a,x,y,c=1234567)
      (((random(0,a) | random(x,y)) + c) % (y - x + 1)) + x
    end

    def self.random_alpha_string(min, max)
      /\w{#{min},#{max}}/.gen
    end

    def self.random_number_string(min, max)
      /\d{#{min},#{max}}/.gen
    end

    def self.random_string(min, max, encode=nil, percent=10)
      length = max
      length = random(min, max) unless min == max

      genstr = /[:paragraph:]/.gen[0, length]

      if not encode.nil? and (random(0,100) <= percent)
          genstr = /[:paragraph:]{10}/.gen[0, length - encode.length]
          idx = random(0, genstr.length - encode.length)
          genstr.insert(idx, encode)
      end
      genstr
    end

    def self.random_last_name
      numstr = self.NURand(255,0,999, $c_last).to_s.split("")
      (3-numstr.length).times { numstr.unshift("0") }
      numstr.map { |x| $last_name_parts[x.to_i]}.join("")
    end

    def self.random_customer_id
      self.NURand(1023, 1, 3000, $c_id)
    end

    def self.random_order_line_item_id
      self.NURand(8191, 1, 100000, $i_id)
    end

    def self.random_carrier_id
      id = random(1,10)
    end

    def self.random_credit
      random(1,100) <= 10 ? "BC" : "GC"
    end
  end

  # DM-Sweatshop is evil and tries to keep a reference to every object allocated.
  class Sweatshop
    class << self
      attr_accessor :object_count
      attr_accessor :object_threshold
    end

    self.record_map = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] = Queue.new }}
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
      klass.get(self.record_map[klass][name.to_sym].pop) || raise(NoFixtureExist, "no #{name} context fixtures have been generated for the #{klass} class")
    end
  end
end
