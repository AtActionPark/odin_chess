class Tower < Piece

  def initialize player
    @player = player
    @type = "T"
    @display = type + player.to_s
    @moves = []
    8.times do |i|
      @moves << [i,0]
      @moves << [-i,0]
      @moves << [0,i]
      @moves << [0,-i]
    end
  end
end