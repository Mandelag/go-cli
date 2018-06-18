require_relative "go-cli"
include Gocli

RSpec.describe Map do
  describe "#Without initialization parameters," do
    it "create default map of 20 x 20 grid." do
      map = MapBuilder.new.build
      expect(map.height).to be(20)
      expect(map.width).to be(20)
    end
  end
  
end