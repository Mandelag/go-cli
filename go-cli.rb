module Gocli
  class MapBuilder
    attr_accessor :width, :height, :map_objects
    def initialize
      @width = 20
      @height = 20
      @map_objects = []
    end
    def build 
      map = Map.new(@height, @width)
      @map_objects.each do |obj|
        map.insert_object(obj)
      end
      map
    end
  end

  class Map
    attr_reader :height
    attr_reader :width
    
    def initialize(height=20, width=20)
      @height = height
      @width = width
      @map_objects = []
    end
    
    def insert_object(object, x=rand(@width), y=rand(@height))
      result = nil
      if x < @width && x >= 0 && y < @height && y >= 0
        result = MapObject.new(object, x, y)
        @map_objects << result
      end
      result
    end
    
    def iterate_object
      @map_objects.each {|objects|  yield(x)}
    end
  end
  
  class MapObject
    attr_reader :object
    attr_accessor :x
    attr_accessor :y
    
    def initialize(object, x, y)
      @object = object
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