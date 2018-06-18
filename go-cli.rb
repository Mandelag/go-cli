class Map
  attr_reader :height
  attr_reader :width
  
  def initialize(height=20, width=20)
    @height = height
    @width = width
    @spatial_objects = []
  end
end

class SpatialObject
  
end

class Driver < SpatialObject
  
end

class User < SpatialObject
  
end

class Order
  
end
