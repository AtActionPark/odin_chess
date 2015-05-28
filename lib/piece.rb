class Piece
  attr_reader :player
  attr_reader :type
  attr_reader :display
  attr_accessor :cell
  attr_accessor :notation

  attr_reader :moves
  attr_reader :special_moves

  def initialize 
    @cell = []
  end

  def valid_move? move
    return @moves.include?(move)
  end

  def update
  end

end