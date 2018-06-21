require_relative "go-cli"
include GoCli

class AppInterface
  def self.main
    app = nil 
    if ARGV.length == 0
      puts "Intialize using default value..."
      app = App.new(20)
    elsif ARGV.length == 1
      puts "Initialize by file..."
      app = App.new(nil,nil,nil,ARGV[0])
    elsif ARGV.length == 3
      app = App.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
    else 
      puts "Invalid parameter length."
      puts "Usage:"
      puts "  ruby main [ file | world_side_length user_x user_y]"
      return
    end
    
    greet
    
    while (response = prompt_user) != 4
      if response == 2
        user_response = prompt_order
        order_response = app.place_order(*user_response)
        puts "---Order confirmation---"
        puts order_response["order"]
        puts "------------------------"
        print "Confirm? > [Y/n]"
        confirm = STDIN.gets.chomp.downcase
        if confirm == "y" || confirm == "yes"
          order_response["response"].call("yes")
          puts "Done!"
        else
          order_response["response"].call("no")
          puts "Order canceled."
        end
      elsif response == 3
        app.display_order_history
      elsif response == 4
        puts "CLOSE!"
        return
      else 
        app.display_map
      end
    end
  end
  
  private
  
  def self.greet
    puts "==============================="
    puts "===                         ==="
    puts "===    WELCOME TO GO-CLI    ==="
    puts "===     v0.0.1-SNAPSHOT     ==="
    puts "===                         ==="
    puts "==============================="
    puts ""
  end
  
  def self.prompt_user
    puts ""
    puts "What do you want to do?"
    puts " 1. Show map"
    puts " 2. Order Go Ride"
    puts " 3. View history"
    puts " 4. Exit application"
    print "> [1] "
    response = STDIN.gets.chomp.to_i
    response
  end
  
  def self.prompt_order
    puts "Where do you want to go? Please enter the coordinate (X,Y)"
    print "X> "
    destination_x = STDIN.gets.chomp.to_i
    print "Y> "
    destination_y = STDIN.gets.chomp.to_i
    [destination_x, destination_y]
  end
end

AppInterface.main()
