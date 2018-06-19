require_relative "go-cli"
include GoCli

class App
  def initialize(side, object_placements, user_x, user_y) 
    if @@order_server.nil?
       map = Map.new(side, side)
       @@order_server = OrderServer.new(map)
    end
    
  end

  def self.main()
    app = nil 
    if ARGV.length == 0
      puts "Intialize using default value..."
      app = App.new(20, )
    elsif ARGV.length == 1
      puts "Initialize by file..."
      
    elsif ARGV.length == 3
      puts "Initialize by parameter..."
      app = App.new()
    else 
      puts "Invalid parameter length."
      puts "Usage:"
      puts "  ruby main [ file | world_side_length user_x user_y]"
      return
    end
    
    puts "==============================="
    puts "===                         ==="
    puts "===    WELCOME TO GO-CLI    ==="
    puts "===     v0.0.1-SNAPSHOT     ==="
    puts "===                         ==="
    puts "==============================="
    puts ""
    puts "What do you want to do?"
    puts " 1. Show Map"
    puts " 2. Order Go Ride"
    puts " 3. View History"
    print "> [1] "
    response = gets.chomp.to_i
    
    if response == 2
      puts "ORDER!"
    elsif response == 3
      puts "HISTORY!"
    else 
      puts "your location -> X"
      puts "...........\n...........\n...........\n...........\n......X...."
    end
  end
end

App.main()
