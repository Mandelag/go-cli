require_relative "go_cli"

RSpec.describe Map do
  describe "#initialize" do
    it "Without init params, create default map of 20 x 20 grid." do
      map = Map.new
      expect(map.height).to be(20)
      expect(map.width).to be(20)
    end
    it "Without init params, place 5 randomly located drivers." do
      map = Map.new
      driver_count = map.spatial_objects.select {|obj| obj.instance_of? Driver}
      expect(driver_count).to be(5)
    end
    it "Without init params, place a randomly located go-cli user." do
      map = Map.new
      user_count = map.spatial_objects.select {|obj| obj.instance_of? User}
      expect(user_count).to be(1)
    end
  end
end