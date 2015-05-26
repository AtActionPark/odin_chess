class Piece
  attr_reader :player
  attr_reader :type
  attr_reader :display
  attr_accessor :cell

  @moves

  def initialize 
    @cell = []
  end

  def valid_move? move
    return @moves.include?(move)
  end

end