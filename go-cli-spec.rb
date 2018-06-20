require_relative "go-cli"
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
    it "Maps are equal when they have the same height, width, and MapObjects (not ordered)." do
      map = Map.get_pre_populated(20, nil, nil)
      str = Map.save(map)
      map_loaded = Map.load(str)
      expect(map == map_loaded).to be(true)
    end
    it "Test save and load" do
      map = Map.new
      map_json_string = map.save()
      map_loaded = Map.load(map_json_string)
      expect(map == map_loaded).to be(true)
    end
  end
end
