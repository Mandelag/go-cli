module GoCli
  class Map
    attr_reader :height
    attr_reader :width
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
  
  class Person
    def initialize(name, phone, address)
      @name = name
      @phone = phone
      @address = address
    end
  end
  
  class Driver < Person
    def initialize(name, phone, address, bike)
      super(name, phone, address)
      @bike = bike
    end
  end
  
  class Order
    
  end
  
  class App
    @@drivers = [
      Driver.new("Wagyu", "+8283xxxxxxx", "Jl. Bukit Sake", "RX King"),
      Driver.new("Budi", "0811xxxxxxx", "Jl. Kober", "Vega-R"),
      Driver.new("Anto", "0881xxxxxxx", "Jl. Bukit Timah", "Yamaha Mio"),
      Driver.new("Grace", "0815xxxxxx", "Jl. Lipatan Bumi", "NMax"),
      Driver.new("Widi", "0809xxxxxxx", "Jl. Bukit Cinere", "Royal Enfield")
    ]
    @@user = Person.new("Keenan", "081388439168", "Jl. Bukit Cinere")
    @@map = nil
    @@unit_cost = 300
    @user_in_map = nil
    
    def initialize(side, user_x=nil, user_y=nil)
      if @@map.nil?
         @@map = Map.new(side, side)
         5.times do
           @@map.place(@@drivers.delete_at(rand(@@drivers.length)), "D")
         end
         @user_in_map = @@map.place(@@user, "X", user_x, user_y)
      end
    end
    
    def place_order(destination_x, destination_y)
      order =  Order.new
      order.timestamp = ""
      order.destination_x = destination_x
      order.destination_y = destination_y
      order.orderer = @user_in_map
      # order.route = map. calculate route
      # order.price = price according to route distance 
      # order.driver = nearest driver
      OrderConfirmation.new(order)
    end
    
    def display_map 
      puts ""
      puts "---Map Legend---"
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
  end
end