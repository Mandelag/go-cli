module Gocli
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
    
    def insert_object(object, symbol=",", x=rand(@width), y=rand(@height))
      result = nil
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
end