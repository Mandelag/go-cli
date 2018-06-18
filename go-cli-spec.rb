require_relative "go-cli"
include Gocli

RSpec.describe Map do
  describe "#Without initialization parameters," do
    it "create default map of 20 x 20 grid." do
      map = MapBuilder.new.build
      expect(map.height).to be(20)
      expect(map.width).to be(20)
    end
    it "randomly inserted map objects will never be outside the grid boundary." do
      map = MapBuilder.new.build
      drivers = [
        Driver.new("Keenan", "081388439168", "Jl. Bukit Cinere", "Piaggio"),
        Driver.new("Budi", "0811xxxxxxx", "Jl. Kober", "Vega-R"),
        Driver.new("Anto", "0881xxxxxxx", "Jl. Bukit Timah", "Yamaha Mio"),
        Driver.new("Grace", "0815xxxxxx", "Jl. Lipatan Bumi", "NMax"),
        Driver.new("Widi", "0809xxxxxxx", "Jl. Bukit Cinere", "Royal Enfield")
      ]
      drivers.each {|driver| map.insert_object(driver)}
      expect(map.iterate_object {|x|}.all {|object| object.x >= 0 && object.x < map.width}).to be(true)
    end
  end
  
end