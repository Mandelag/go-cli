require_relative "go-cli"

RSpec.describe Map do
  describe "#Without initialization parameters," do
    it "create default map of 20 x 20 grid." do
      map = Map.new
      expect(map.height).to be(20)
      expect(map.width).to be(20)
    end
    it "place 5 randomly located drivers." do
      map = Map.new
      driver_count = map.spatial_objects.select {|obj| obj.instance_of? Driver}
      expect(driver_count).to be(5)
    end
    it "place a randomly located go-cli user." do
      map = Map.new
      user_count = map.spatial_objects.select {|obj| obj.instance_of? User}
      expect(user_count).to be(1)
    end
  end
  
  describe "#With one initialization parameter," do
    it "create the map with grid with the same height and width" do
      parameter = 20
      map = Map.new(parameter)
      expect(map.height).to be(parameter)
      expect(map.width).to be(parameter)
    end
  end
  
  describe "#With two initialization parameter," do
    it "create the map with grid with different height and width" do
      height = 10
      width = 20
      map = Map.new(height, width)
      expect(map.height).to be(height)
      expect(map.width).to be(width)
    end
  end
  
end