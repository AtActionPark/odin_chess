require_relative 'lib/board'
require_relative 'lib/piece'
require_relative 'lib/pawn'
require_relative 'lib/king'
require_relative 'lib/queen'
require_relative 'lib/bishop'
require_relative 'lib/knight'
require_relative 'lib/tower'

@play = true

def load_game
  content = File.open('saves/saved_game.yaml', 'r') {|file| file.read }
  YAML.load(content)
end

if @play 
puts "Type NEW or LOAD"
input = gets.chomp

if input == "NEW" 
  board = Board.new
else
  board = load_game
  board.resume_game
end

board.play
end
