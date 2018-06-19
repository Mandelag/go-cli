require_relative "go-cli"
include GoCli

def initialize_application() 
  
end

def main()
  if ARGV.length == 0
    puts "Intialize using default value..."
  elsif ARGV.length == 1
    puts "Initialize by file..."
  elsif ARGV.length == 3
    puts "Initialize by parameter..."
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
end

main()
