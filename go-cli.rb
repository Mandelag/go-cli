module GoCli
  class Map
    attr_reader :height, :width
    attr_accessor :map_objects
    
    def initialize(height=20, width=20)
      @height = height
      @width = width
      @map_objects = []
      @spatial_index = {}
    end
    
    def place(object, symbol=",", x=nil , y=nil)
      result = nil
      x = rand(@width) unless !x.nil?
      y = rand(@height) unless !y.nil?
      if x < @width && x >= 0 && y < @height && y >= 0
        result = MapObject.new(object, symbol, x, y)
        @map_objects << result
      end
      result
    end
    
    def rebuild_spatial_index
      spatial_index = Hash.new({})
      @map_objects.each do |obj|
        if spatial_index[obj.y].size == 0
          spatial_index[obj.y] = Hash.new({})
        end
        if spatial_index[obj.y][obj.x].size == 0
          spatial_index[obj.y][obj.x] = []
        end
        spatial_index[obj.y][obj.x] << obj
      end
      spatial_index
    end
    
    def display
      spatial_index = rebuild_spatial_index
      @height.times do |y|
        row = ""
        @width.times do |x|
          if !spatial_index[y][x].nil?
            if spatial_index[y][x].length == 0
              row += "."
            elsif spatial_index[y][x].length == 1
              row += spatial_index[y][x][0].symbol
            else 
              row += "*"
            end
          else
            row += "."
          end
        end
        puts row
      end
    end
    
    def route(start_x, start_y, dest_x, dest_y)
      route = Route.new(start_x, start_y, dest_x, dest_y)
      route.freeze
      route
    end
    
    def find_nearest(search_x, search_y, class_string)
      @map_objects.each {|obj| puts "class: #{obj.object.name} x: #{obj.x} y: #{obj.y}"}
      select = @map_objects.select {|obj| obj.object.is_a?(Module.const_get(class_string))}
      select = select.min {|a,b| ((a.x-search_x).abs + (a.y-search_y).abs) <=> ((b.x-search_x).abs + (b.y-search_y).abs) }
      select.object
    end
    
    def self.get_pre_populated(side, user_x, user_y)
      drivers = [
        Driver.new("Keenan", "081388439168", "Jl. Bukit Cinere", "Piaggio"),
        Driver.new("Budi", "0811xxxxxxx", "Jl. Kober", "Vega-R"),
        Driver.new("Anto", "0881xxxxxxx", "Jl. Bukit Timah", "Yamaha Mio"),
        Driver.new("Grace", "0815xxxxxx", "Jl. Lipatan Bumi", "NMax"),
        Driver.new("Widi", "0809xxxxxxx", "Jl. Bukit Cinere", "Royal Enfield")
      ]
      user = Person.new("Keenan", "081388439168", "Jl. Bukit Cinere")
      map = Map.new(side, side)
      5.times do
        map.place(drivers.delete_at(rand(drivers.length)), "D")
      end
      @user_in_map = map.place(user, "X", user_x, user_y)
      map
    end
  end
  
  class MapObject
    attr_reader :object, :symbol
    attr_accessor :x, :y
    def initialize(object, symbol, x, y)
      @object = object
      @symbol = symbol
      @x = x
      @y = y
    end
  end
  
  class Route 
    attr_reader :distance, :start_x, :start_y, :dest_x, :dest_y
    def initialize(start_x, start_y, dest_x, dest_y)
      @start_x = start_x 
      @start_y = start_y
      @dest_x = dest_x
      @dest_y = dest_y
      @distance = (start_x-dest_x).abs + (start_y-dest_y).abs - 1
    end
  end
  
  class Person
    attr_accessor :name, :phone, :address
    def initialize(name, phone, address)
      @name = name
      @phone = phone
      @address = address
    end
  end
  
  class Driver < Person
    attr_accessor :bike
    def initialize(name, phone, address, bike)
      super(name, phone, address)
      @bike = bike
    end
  end
  
  class Order
    attr_accessor :unit_price, :price, :driver, :route, :orderer
    def initialize
      @timestamp = Time.now
      @price = 300
      @route = "test route"
      @orderer = "orderer"
      @driver = Driver.new("Pak Haji Ali","01392839xx","Jl. Kedondong","Supra")
    end
    
    def to_s
      "-------------------"
      "Order date: #{@timestamp.to_s}\r\n"+
      "Orderer: #{@orderer.name}\r\n"+
      "Price: #{@price.to_s}\r\n"+
      "Distance: #{(@route.length-1).to_s} units\r\n"+
      "Total price: #{((@route.length-1)*@price).to_s}\r\n"+
      "Driver:\r\n  Name: #{@driver.name}\r\n  Phone: #{@driver.phone}\r\n  Motorcycle: #{@driver.bike}"
    end
  end
  
  class App
    @@map = nil
    @@unit_cost = 300
    @user_in_map = nil
    
    def initialize(side, user_x=nil, user_y=nil)
      if @@map.nil?
         @@map = Map.get_pre_populated_map(side, user_x, user_y)
      end
      @orders = []
    end
    
    def place_order(destination_x, destination_y)
      order =  Order.new
      order.orderer = @user_in_map.object
      # order.route = map. calculate route
      # order.price = price according to route distance 
      puts @user_in_map.x, @user_in_map.y
      order.driver = @@map.find_nearest(@user_in_map.x, @user_in_map.y, "Driver")
      order.freeze
      response = lambda do |answer|
        if answer.downcase == "yes"
          @orders << order
        end
      end
      {"order" => order, "response" => response}
    end
    
    def display_map
      puts ""
      puts "---Map legend---"
      puts ""
      puts " X => Your location"
      puts " D => Driver location"
      puts " * => More than 1 object at one location"
      puts ""
      puts "------Maps------"
      puts ""
      @@map.display
      puts ""
      puts "----------------"
    end
    
    def display_order_history
      puts ""
      puts "---Order history---"
      @orders.each do |order|
        puts order.to_s
        puts "-------------------"
      end
      puts "-------------------"
      puts ""
    end
  end
end