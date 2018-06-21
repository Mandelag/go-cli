require_relative "go-cli"
require "json"
include GoCli

RSpec.describe Map do
  describe "#Without initialization parameters," do
    it "Create default map of 20 x 20 grid." do
      map = Map.new
      expect(map.height).to be(20)
      expect(map.width).to be(20)
    end
    it "Randomly inserted map objects will never be outside the grid boundary." do
      map = Map.get_pre_populated(20, nil, nil)
      expect(map.map_objects.all? {|object| object.x >= 0 && object.x < map.width}).to be(true)
    end
  end
  
  describe "#Load, save, equal, and other related tests." do
    it "Test save and load." do
      map = Map.get_pre_populated(20, nil, nil)
      map_string = map.save()
      map_loaded = Map.load(map_string)
      expect(map == map_loaded).to be(true)
    end
  end
end

RSpec.describe Route do
  describe "Initialization" do
    it "Given a pair of coordinates (start and end), return a list of route coordinates." do
      map_side = 20
      start_x, start_y = rand(20), rand(20)
      dest_x, dest_y = rand(20), rand(20)
      map = Map.get_pre_populated(20, nil, nil)
      route = map.route(start_x, start_y, dest_x, dest_y)
      if route.found
        expect(route.coordinates >= 2).to be(true)
        expect(route.coordinates[0] == [start_x, start_y]).to be(true)
        expect(route.coordinates[-1] == [dest_x, dest_y]).to be(true)
        for i in 1...route.coordinates.length
          front_coordinates = route.coordinates[i]
          back_coordinates = route.coordinates[i-1]
          horizontal_movement = (front_coordinates[0]-back_coordinates[0]).abs
          vertical_movement = (front_coordinates[1]-back_coordinates[1]).abs
          expect(horizontal_movement+vertical_movement).to be <= 1
        end
      end
    end
  end
end
