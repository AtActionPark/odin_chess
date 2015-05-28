class Knight < Piece

  def initialize player
    @player = player
    @type = "N"
    @display = type + player.to_s

    @moves = []
    @moves << [2, -1]
    @moves << [2, 1]
    @moves << [-2, -1]
    @moves << [-2, 1]
    @moves << [1, -2]
    @moves << [1, 2]
    @moves << [-1, -2]
    @moves << [-1, 2]
  end
end