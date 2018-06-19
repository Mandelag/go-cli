require_relative "go-cli"
include GoCli

class App
  @@drivers = [
    Driver.new("Wagyu", "+8283xxxxxxx", "Jl. Bukit Sake", "RX King"),
    Driver.new("Budi", "0811xxxxxxx", "Jl. Kober", "Vega-R"),
    Driver.new("Anto", "0881xxxxxxx", "Jl. Bukit Timah", "Yamaha Mio"),
    Driver.new("Grace", "0815xxxxxx", "Jl. Lipatan Bumi", "NMax"),
    Driver.new("Widi", "0809xxxxxxx", "Jl. Bukit Cinere", "Royal Enfield")
  ]
  @@user = Person.new("Keenan", "081388439168", "Jl. Bukit Cinere")
  @@map = nil
  
  def initialize(side, user_x=nil, user_y=nil)
    if @@map.nil?
       @@map = Map.new(side, side)
       5.times do
         @@map.place(@@drivers.delete_at(rand(@@drivers.length)), "D")
       end
       @@map.place(@@user, "X", user_x, user_y)
    end
  end
  
  def display_map 
    puts ""
    puts "---Map Legend---"
    puts ""
    puts " X => Your location"
    puts " D => Driver location"
    puts " * => More than 1 object at one location"
    puts ""
    puts "------Maps------"
    puts ""
    @@map.display
    puts ""
    puts "----------------"
  end
  
  def print_application_header
    puts "==============================="
    puts "===                         ==="
    puts "===    WELCOME TO GO-CLI    ==="
    puts "===     v0.0.1-SNAPSHOT     ==="
    puts "===                         ==="
    puts "==============================="
    puts ""
  end
  
  def prompt_user
    puts "What do you want to do?"
    puts " 1. Show map"
    puts " 2. Order Go Ride"
    puts " 3. View history"
    puts " 4. Exit application"
    print "> [1] "
    response = STDIN.gets.to_i
    response
  end
  
  def self.main()
    app = nil 
    if ARGV.length == 0
      puts "Intialize using default value..."
      app = App.new(20)
    elsif ARGV.length == 1
      puts "Initialize by file..."
      app = App.new(20)
    elsif ARGV.length == 3
      app = App.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
    else 
      puts "Invalid parameter length."
      puts "Usage:"
      puts "  ruby main [ file | world_side_length user_x user_y]"
      return
    end
    
    app.print_application_header
    
    while (response = app.prompt_user) != 4
      if response == 2
        puts "ORDER!"
      elsif response == 3
        puts "HISTORY!"
      elsif response == 4
        puts "CLOSE!"
        return
      else 
        app.display_map
      end
    end
    
  end
end

App.main()
