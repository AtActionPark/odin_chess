class Piece
  attr_reader :player
  attr_reader :type
  attr_reader :display

  @moves

  def initialize 
    
  end

  def valid_move? move
    return @moves.include?(move)
  end

end