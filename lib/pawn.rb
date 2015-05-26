class Pawn < Piece

  def initialize player
    @player = player
    @type = "p"
    @display = type + player.to_s
    @moves = []
    if player == 1
      @moves<<[0,1]
    else
      @moves << [0,-1]
    end
  end

end