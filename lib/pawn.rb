class Pawn < Piece

  def initialize player
    @player = player
    @type = "p"
    @display = type + player.to_s
    @moves = []
    @special_moves = []
    if player == 1
      @moves<<[0,1]
      @moves<<[0,2]
      @special_moves << [1,1]
      @special_moves << [-1,1]
    else
      @moves << [0,-1]
      @moves << [0,-2]
      @special_moves << [1,-1]
      @special_moves << [-1,-1]
    end
  end

  def update
    @moves.clear
    if player == 1
      @moves<<[0,1]
    else
      @moves << [0,-1]
    end
  end

  def valid_move? move, capture
    return @moves.include?(move) if capture == false
    return @special_moves.include?(move) if capture == true
  end

end