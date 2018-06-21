require "json"

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
      Route.lurus_lurus_algorithm(start_x, start_y, dest_x, dest_y)
    end
    
    def find_nearest(search_x, search_y, class_string)
      #@map_objects.each {|obj| puts "class: #{obj.object.name} x: #{obj.x} y: #{obj.y}"}
      select = @map_objects.select {|obj| obj.object.is_a?(Module.const_get(class_string))}
      select = select.min {|a,b| ((a.x-search_x).abs + (a.y-search_y).abs) <=> ((b.x-search_x).abs + (b.y-search_y).abs) }
      select
    end
    
    def find_by_location(search_x, search_y, class_string)
      spatial_index = rebuild_spatial_index
      objects = spatial_index[search_y][search_x]
      objects = objects.select {|obj| obj.object.is_a?(Module.const_get(class_string))}
      objects = objects.map {|obj| obj.object}
      objects
    end
    
    def save()
      to_json
    end
    
    def self.load(json_string)
      map = JSON.parse(json_string)
      self.json_create(map)
    end
    
    def to_json(*a)
      {"json_class" => self.class.name,
       "data" => {
          "width" => @width,
          "height" => @height,
          "map_objects" => @map_objects
        }
      }.to_json(*a)
    end
    
    def ==(o)
      o.class == self.class && o.state == state
    end
    
    def state
      [@width, @height, @map_objects]
    end
    
    def self.json_create(o)
      map = Map.new(o["data"]["height"], o["data"]["width"])
      o["data"]["map_objects"].each do |map_object|
        obj =  Module.const_get(map_object["data"]["object"]["json_class"]).json_create(map_object["data"]["object"])
        symbol = map_object["data"]["symbol"]
        x = map_object["data"]["x"]
        y = map_object["data"]["y"]
        map.place(obj, symbol, x, y)
      end
      map
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
    
    def to_json(*a)
      {"json_class" => self.class.name,
       "data" => {
          "object" => @object,
          "symbol" => @symbol,
          "x" => @x,
          "y" => @y
        }
      }.to_json(*a)
    end
    
    def self.json_create(o)
      #puts Module.const_get(o["json_class"]).json_create(o["data"]["object"])
      new(o["data"]["symbol"], o["data"]["x"], o["data"]["y"])
    end
  end
  
  class Route 
    attr_reader :start_x, :start_y, :dest_x, :dest_y
    attr_accessor :distance, :coordinates, :found
    def initialize(start_x, start_y, dest_x, dest_y)
      @start_x = start_x 
      @start_y = start_y
      @dest_x = dest_x
      @dest_y = dest_y
    end
    
    def self.lurus_lurus_algorithm(start_x, start_y, dest_x, dest_y)
      route = Route.new(start_x, start_y, dest_x, dest_y)
      #print [start_x, start_y, dest_x, dest_y]
      horizontal_movement = []
      
      if dest_x >= start_x
        horizontal_movement = Array(start_x.upto(dest_x))
      else 
        horizontal_movement = Array(start_x.downto(dest_x))
      end
      if dest_y >= start_y
        vertical_movement = Array(start_y.upto(dest_y))
      else 
        vertical_movement = Array(start_y.downto(dest_y))
      end
      
      vertical_movement.delete_at(0)
      horizontal_coordinates = horizontal_movement.zip([start_y]*horizontal_movement.length)
      vertical_coordinates = ([horizontal_movement[-1]]*vertical_movement.length).zip(vertical_movement)
      route_coordinates = horizontal_coordinates + vertical_coordinates
      route.coordinates = route_coordinates
      route.found = true
      route
    end
  end
  
  class Person
    attr_accessor :name, :phone, :address
    def initialize(name, phone, address)
      @name = name
      @phone = phone
      @address = address
    end
    
    def to_json(*a)
      {"json_class" => self.class.name,
       "data" => {
          "name" => @name,
          "phone" => @phone,
          "address" => @address
        }
      }.to_json(*a)
    end
    
    def self.json_create(o)
      new(o["data"]["name"], o["data"]["phone"], o["data"]["address"])
    end
  end
  
  class Driver < Person
    attr_accessor :bike
    def initialize(name, phone, address, bike)
      super(name, phone, address)
      @bike = bike
    end
    
    def to_json(*a)
      {"json_class" => self.class.name,
       "data" => {
          "name" => @name,
          "phone" => @phone,
          "address" => @address,
          "bike" => @bike
        }
      }.to_json(*a)
    end
    
    def self.json_create(o)
      new(o["data"]["name"], o["data"]["phone"], o["data"]["address"], o["data"]["bike"])
    end
  end
  
  class Order
    attr_accessor :unit_price, :price, :driver, :route, :orderer
    def initialize
      @timestamp = Time.now
    end
    
    def to_s
      "-------------------"
      "Order date: #{@timestamp.to_s}\r\n"+
      "Orderer: #{@orderer.object.name}\r\n  Location: #{orderer.x}, #{orderer.y}\r\n"+
      "Price: #{@unit_price.to_s}\r\n"+
      "Distance: #{(@route.coordinates.length-1).to_s} units\r\n"+
      "Total price: #{@price.to_s}\r\n"+
      "Driver:\r\n  Name: #{@driver.object.name}\r\n  Location: #{@driver.x},#{@driver.y}\r\n  Phone: #{@driver.object.phone}\r\n  Motorcycle: #{@driver.object.bike}"
    end
  end
  
  class App
    @@unit_cost = 300
    @user_in_map = nil
    
    def initialize(side, user_x=nil, user_y=nil, map_file=nil)
      if map_file.nil?
        @map = Map.get_pre_populated(side, user_x, user_y)
      else
        map_file_string = File.read(map_file)
        @map = Map.load(map_file_string)
      end
      @orders = []
      @user_in_map = @map.map_objects.select {|obj| obj.object.instance_of? Person}[0]
      #puts @user_in_map
    end
    
    def save_map
      @map.save
    end
    
    def place_order(destination_x, destination_y)
      order =  Order.new
      order.orderer = @user_in_map
      order.route = @map.route(@user_in_map.x, @user_in_map.y, destination_x, destination_y)
      order.unit_price = @@unit_cost
      order.price = (order.route.coordinates.length-1)*@@unit_cost
      order.driver = @map.find_nearest(@user_in_map.x, @user_in_map.y, "Driver")      
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
      @map.display
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