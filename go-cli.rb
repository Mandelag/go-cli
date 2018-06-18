class Map
  attr_reader :height
  attr_reader :width
  
  def initialize(height=20, width=20)
    @height = height
    @width = width
    @map_objects = []
  end
  
  def insert_object(object, x, y)
    result = nil
    if x < @width && x >= 0 && y < @height && y >= 0
      result = MapObject.new(object, x, y)
      @map_objects << result
    end
    result
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
